Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2DJPuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:50:16 -0400
Received: from forward14.mail.yandex.net ([95.108.130.92]:58624 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260Ab2DJPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:50:14 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 11:50:14 EDT
Message-ID: <4F84544D.9060406@yandex.ru>
Date: Tue, 10 Apr 2012 19:39:57 +0400
From: Alex Stone <alex.parchment@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120406 Thunderbird/11.0.1
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Timing 250 versus 1000
References: <4F815FCE.5040002@yandex.ru> <4F818DBA.3080108@ladisch.de> <4F81CE0A.6080207@yandex.ru> <4F840599.7060805@ladisch.de>
In-Reply-To: <4F840599.7060805@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 02:04 PM, Clemens Ladisch wrote:
> Alex Stone wrote:
>> On 04/08/2012 05:08 PM, Clemens Ladisch wrote:
>>> Alex Stone wrote:
>>>> those of us who write a lot of midi driven work, we're still more or
>>>> less required to use some sort of RT kernel to get any degree of
>>>> playback timing accuracy.
>>> The ALSA sequencer timer stopped using the system timer years ago.
>>> And the difference between RT and 'normal' kernels is not the timer
>>> frequency.
>> I'm using jack with seq, so are you saying the ALSA sequencer timer is
>> using a higher timer rate than than is set in the kernel,
> It's using different timers (RTC or hrtimer), which support higher
> precision.
>
>> and there's no need for me to bother with this,
> Yes.  If you want to be sure, check that G3 appears in /proc/asound/timers
> when you're using the sequencer.
>
>
> Regards,
> Clemens
It does.

Thanks for the info.

Regards,
Alex.
