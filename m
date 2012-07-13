Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2GMUtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:49:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49253 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab2GMUto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:49:44 -0400
Message-ID: <500089C4.3040300@linaro.org>
Date: Fri, 13 Jul 2012 13:49:08 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/8] Time fixes and cleanups for 3.6
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org> <20120713060520.GG18065@gmail.com>
In-Reply-To: <20120713060520.GG18065@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071320-1976-0000-0000-00000F2CB44B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 11:05 PM, Ingo Molnar wrote:
>
> Looks sensible.
>
> Reviewed-by: Ingo Molnar <mingo@kernel.org>
>
> Thanks,
>
> 	Ingo
>


Thanks for the review! I've added your changes and your reviewed by tag 
and pushed it out to my fortglx/3.6/time branch.

Here's the updated pull request below (Sorry for the word-wrap, 
thunderbrid on my laptop isn't wanting to preserve the preformatting for 
some reason).

thanks
-john


The following changes since commit 5baefd6d84163443215f4a99f6a20f054ef11236:

   hrtimer: Update hrtimer base offsets each hrtimer_interrupt 
(2012-07-11 23:34:39 +0200)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.6/time

for you to fetch changes up to bbe1c99bd1000f64b117d462ea1c5041f81fb179:

   time: Rework timekeeping functions to take timekeeper ptr as argument 
(2012-07-13 16:39:02 -0400)

----------------------------------------------------------------
John Stultz (8):
       ntp: Fix STA_INS/DEL clearing bug
       time: Whitespace cleanups per Ingo's requests
       time: Explicitly use u32 instead of int for shift values
       time: Condense timekeeper.xtime into xtime_sec
       time: Refactor accumulation of nsecs to secs
       time: Move arch_gettimeoffset() usage into timekeeping_get_ns()
       time: Move xtime_nsec adjustment underflow handling 
timekeeping_adjust
       time: Rework timekeeping functions to take timekeeper ptr as argument

  kernel/time/ntp.c         |    8 +-
  kernel/time/timekeeping.c |  486 
++++++++++++++++++++++++---------------------
  2 files changed, 267 insertions(+), 227 deletions(-)


