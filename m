Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0EYPUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:20:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205Ab0EYPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:20:04 -0400
Date: Tue, 25 May 2010 08:16:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Michel Lespinasse <walken@google.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical()
 proposal
In-Reply-To: <1274777239.5882.581.camel@twins>
Message-ID: <alpine.LFD.2.00.1005250815101.3689@i5.linux-foundation.org>
References: <1274733081-4623-1-git-send-email-walken@google.com> <1274777239.5882.581.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 May 2010, Peter Zijlstra wrote:
> 
> So what happened to those patches that dropped mmap_sem during I/O?

They were horrible. The amount of retrying was just nasty. I don't think 
it's going to ever be a viable approach.

Feel free to prove me wrong with clean patches, but I doubt you can.

		Linus
