Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0DFNfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:35:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0DFNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:35:37 -0400
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4BBB36FA.4020008@redhat.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	 <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com>
	 <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com>
	 <4BBB36FA.4020008@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 15:35:31 +0200
Message-ID: <1270560931.1595.342.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 16:28 +0300, Avi Kivity wrote:
> 
> Yes, but that's the best case for spinning.  You could simply use a 
> userspace spinlock in this case. 

Userspace spinlocks are evil.. they should _never_ be used.

