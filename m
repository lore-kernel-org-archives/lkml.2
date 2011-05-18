Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1ERT5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:57:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab1ERT5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:57:16 -0400
Date: Wed, 18 May 2011 12:56:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
Message-Id: <20110518125616.b57e1881.akpm@linux-foundation.org>
In-Reply-To: <20110518194811.GD6225@elte.hu>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
	<20110518062554.GB2945@elte.hu>
	<1305745409.2915.178.camel@work-vm>
	<20110518123335.62785884.akpm@linux-foundation.org>
	<20110518194811.GD6225@elte.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 21:48:11 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Dunno, %ptc ties into lowlevel sprintf() and takes a spinlock!

yup, that's a problem.

> Oh, out of morbid curiosity, mind providing a log of bigger past incidents 
> where you had to stick pins into a doll of me? (In private mail, if the list is 
> too long ;-)

http://0.tqn.com/d/urbanlegends/1/0/m/B/porcupine2.jpg
