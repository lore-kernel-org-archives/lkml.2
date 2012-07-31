Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2GaRuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:50:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44840 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab2GaRue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:50:34 -0400
Message-ID: <50181A28.3010207@linaro.org>
Date: Tue, 31 Jul 2012 10:47:20 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 0/2][RFC] Better handling of insane CMOS values
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073117-7182-0000-0000-0000021E763A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 11:35 PM, John Stultz wrote:
> I've also only been able to lightly test. If you want to try this out
> you can add the following to timekeeping_init after the
> read_persistent_clock() call:
>
> 	now.tv_sec = 196469280000LL;
Prarit noted that I implemented these patches against 3.5 (what the 
problem was reported against) and not Linus' head.

I'm mostly just looking for input on the approach, but just in case 
anyone else wanted to actually play with these patches, they'll need to 
do so against 3.5. I'll  update the patchset against Linus' tree before 
I send them out again.

Sorry about that.

thanks
-john

