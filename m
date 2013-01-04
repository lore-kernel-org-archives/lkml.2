Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3ADNKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:10:52 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53413 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3ADNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:10:50 -0500
Message-ID: <50E6D4C5.8070408@ahsoftware.de>
Date: Fri, 04 Jan 2013 14:10:29 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/4 v5 RESEND] rtc: add rtc-driver for HID sensors of
 type time
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de> <1355575537-10093-3-git-send-email-holler@ahsoftware.de> <20130103143913.16d4e867.akpm@linux-foundation.org> <alpine.LNX.2.00.1301041017540.9143@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301041017540.9143@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.01.2013 10:18, schrieb Jiri Kosina:
> On Thu, 3 Jan 2013, Andrew Morton wrote:
>
>>> This driver makes the time from HID sensors (hubs) which are offering
>>> such available like any other RTC does.

>> Looks OK to me.  It sounds like Jonathan will be merging these patches
>> when he's happy with them - please do proceed that way.
>
> Yes, fine by me as well -- that's why I have provided by explicit Acks to
> those.
>
> Jonathan, are you taking those, please?

Thanks to all.

Btw. if someone wants to build such a pluggable HID-USB-RTC using an AVR 
(Arduino Leonardo, or an ATtiny with v-usb), feel free to contact me. I 
have some working sources around and will write a website with "exact 
steps" ;) if I find the time. Currently the stuff is still in ugly 
state, but if someone needs a starting point (e.g. for the HID 
descriptors), it is already usable.

Regards,

Alexander
