Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2GSDqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 23:46:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55959 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2GSDqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 23:46:20 -0400
Message-ID: <500782F8.1060208@us.ibm.com>
Date: Wed, 18 Jul 2012 20:46:00 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] alarmtimer: add .remove_dev hook to put device
References: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org> <500743DD.5070600@linaro.org>	<5007457F.1010404@us.ibm.com> <CAAQ0ZWSmKPUEB380H9ftL-VXYQywwedQRweWqqAi1emhp2g_cA@mail.gmail.com>
In-Reply-To: <CAAQ0ZWSmKPUEB380H9ftL-VXYQywwedQRweWqqAi1emhp2g_cA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071903-5518-0000-0000-000006253EA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 06:23 PM, Shawn Guo wrote:
> On 19 July 2012 07:23, John Stultz <johnstul@us.ibm.com> wrote:
>> Actually, this change opens up a bunch of other races, as any caller of
>> alarmtimer_get_rtcdev() could have the rtcdevice removed under it.
>>
>> We'll need to have proper reference counting w/ get/put calls, probably also
>> adding a alarmtimer_put_rtcdev() interface.
>>
>> So for now I'm dropping this from my tree.  Do you think you might be able
>> to take another stab at this?
>>
> No.  You can take the patch as a bug report and fix it yourself in the
> best way you can think of :)
Ok. I'll try to find some time to do that.

Thanks!
-john

