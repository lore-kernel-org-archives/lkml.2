Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2GaB7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 21:59:48 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:37279 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2GaB7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 21:59:47 -0400
Date: Mon, 30 Jul 2012 21:59:31 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>
Message-ID: <694779256.2105549.1343699971959.JavaMail.root@redhat.com>
In-Reply-To: <5016CA28.8020402@us.ibm.com>
Subject: Re: boot panic regression introduced in 3.5-rc7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.236]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On 07/29/2012 08:51 PM, CAI Qian wrote:
> > The bisecting pointed out this patch caused one of dell servers
> > boot panic.
> >
> >    5baefd6d84163443215f4a99f6a20f054ef11236
> >    hrtimer: Update hrtimer base offsets each hrtimer_interrupt
> >
> > [    2.971092] WARNING: at kernel/time/clockevents.c:209
> > clockevents_program_event+0x10a/0x120()
> 
> Thanks for the report! Just to confirm, you're seeing this with the
> final 3.5?
Yes, and the latest linus and tip trees too.
> 
> I'll let you know as soon as I've got something to test.
> 
> thanks
> -john
> 
> 
