Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1FFUWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:22:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab1FFUWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:22:04 -0400
MIME-Version: 1.0
X-Originating-IP: [192.91.75.30]
In-Reply-To: <20110331153010.GD2704@sortiz-mobl>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<20110325142648.GC3879@sortiz-mobl>
	<99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
	<201103291305.02293.arnd@arndb.de>
	<20110331141650.GB2704@sortiz-mobl>
	<99B09243E1A5DA4898CDD8B7001114481085F0FE7C@EXMB04.eu.tieto.com>
	<20110331153010.GD2704@sortiz-mobl>
Date: Mon, 6 Jun 2011 15:22:01 -0500
Message-ID: <BANLkTimsZeqvSWj+kKWLSmFOQc70KWodcw@mail.gmail.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
From: Pavan Savoy <pavan_savoy@sify.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Waldemar.Rymarkiewicz@tieto.com, arnd@arndb.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, alan@lxorguk.ukuu.org.uk,
        Sebastian.Chlad@tieto.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 9:30 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Thu, Mar 31, 2011 at 06:24:50PM +0300, Waldemar.Rymarkiewicz@tieto.com wrote:
>> Hi Samuel,
>>
>> >That's the Bluetooth approach, and it works just fine as well.
>> >However, the netlink option for sending commands and receiving
>> >answers to/from a subsystem sounds more appropriate, at least to me.
>>
>> I haven't used netlink in practice, so just wondering why netlink. I assume, then, it's more suitable :)
>>
> Have a look at the wireless nl80211.c implementation. It's a good example for
> that sort of usage.

So, why was the network interface 'ala eth0 or the netlink interface dropped?
I saw these patches recently "NFC: add nfc subsystem core" - which
seem to add just the device /dev/nfc - am I correct ?
Or missing something ?

> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
