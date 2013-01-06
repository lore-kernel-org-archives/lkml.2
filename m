Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3AFLup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:50:45 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55976 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3AFLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:50:44 -0500
Message-ID: <50E96510.7020201@kernel.org>
Date: Sun, 06 Jan 2013 11:50:40 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/4 v5 RESEND] rtc: add rtc-driver for HID sensors of
 type time
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de> <1355575537-10093-3-git-send-email-holler@ahsoftware.de> <20130103143913.16d4e867.akpm@linux-foundation.org> <alpine.LNX.2.00.1301041017540.9143@pobox.suse.cz> <50E6D4C5.8070408@ahsoftware.de>
In-Reply-To: <50E6D4C5.8070408@ahsoftware.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 01:10 PM, Alexander Holler wrote:
> Am 04.01.2013 10:18, schrieb Jiri Kosina:
>> On Thu, 3 Jan 2013, Andrew Morton wrote:
>>
>>>> This driver makes the time from HID sensors (hubs) which are offering
>>>> such available like any other RTC does.
> 
>>> Looks OK to me.  It sounds like Jonathan will be merging these patches
>>> when he's happy with them - please do proceed that way.
>>
>> Yes, fine by me as well -- that's why I have provided by explicit Acks to
>> those.
>>
>> Jonathan, are you taking those, please?
> 
Added to togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks all,

> Thanks to all.
> 
> Btw. if someone wants to build such a pluggable HID-USB-RTC using an AVR (Arduino Leonardo, or an ATtiny with v-usb),
> feel free to contact me. I have some working sources around and will write a website with "exact steps" ;) if I find the
> time. Currently the stuff is still in ugly state, but if someone needs a starting point (e.g. for the HID descriptors),
> it is already usable.
> 
> Regards,
> 
> Alexander
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
