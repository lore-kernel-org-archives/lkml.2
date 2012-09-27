Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2I0VsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:48:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49452 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab2I0VsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:48:22 -0400
Message-ID: <5064C99E.9050801@linaro.org>
Date: Thu, 27 Sep 2012 14:48:14 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] 3.2-stable timekeeping fixes merged in 3.6
References: <1347402926-34813-1-git-send-email-john.stultz@linaro.org> <20120927203911.GC19489@kroah.com>
In-Reply-To: <20120927203911.GC19489@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092721-5930-0000-0000-00000C8B4B70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 01:39 PM, Greg KH wrote:
> On Tue, Sep 11, 2012 at 06:35:23PM -0400, John Stultz wrote:
>> Just wanted to send out a few timekeeping fixes that were merged
>> in 3.6 which are appropriate for -stable.
>>
>> This queue backports the following fixes:
>> -----------------------------------------
>> cee58483cf56e0ba355fdd97ff5e8925329aa936    time: Move ktime_t overflow checking into timespec_valid_strict
>> bf2ac312195155511a0f79325515cbb61929898a    time: Avoid making adjustments if we haven't accumulated anything
>> 4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b    time: Improve sanity checking of timekeeping inputs
>>
>> I've run these through my timetest suite w/ kvm on both i386
>> & x86_64. But more testing would be of course appreciated.
>> 	https://github.com/johnstultz-work/timetests
>>
>> I also have patch queues for all the -stable trees that I'll be
>> sending out as my testing completes for those trees.
> Did you also send these out for the 3.0.y tree and I just missed them?
> Should I just take this 3.2.y series and see how they well apply?
I did send them out for 3.0, on  Sep 11.

Let me know if you can't find them and I'll resend.

thanks
-john



