Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2KMIME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:12:04 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57207 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2KMIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:12:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1211130845270.15877@pobox.suse.cz>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1211130845270.15877@pobox.suse.cz>
Date: Tue, 13 Nov 2012 09:12:00 +0100
Message-ID: <CAN+gG=G5JY8wPrOuCws36NWRXjxS62wiutoZgSuhvAZG=8yxKg@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] Win 8 support for digitizers
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Nov 13, 2012 at 8:47 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 7 Nov 2012, Benjamin Tissoires wrote:
>
>> Hi Guys,
>>
>> here is the third version of this patchset.
>> I think I included most of Henrik's comments.
>>
>> Happy reviewing :)
>>
>> Cheers,
>> Benjamin
>>
>> v1 introduction:
>> So, this is an update for supporting Win 8 multitouch devices in the kernel.
>> As I wanted to reliably forward the resolution, I noticed a bug in the
>> processing of the unit_exponent in the hid core layer.
>> Thus the fixes for hid-core and hid-input.
>>
>> v2 changes:
>> * added missing initial patch that prevents the series to be applied on top of Jiri's tree
>> * update to include latest hid changes
>> * taken into account Alan's patch: "hid: put the case in the right switch statement"
>>
>> v3 changes:
>> * splitted "round return value of hidinput_calc_abs_res" in a separate patch
>> * export snto32 in hid.h as we need to use it in hid-input.c
>> * didn't change all drivers, but add a field in hid_usage instead
>> * add quirk MT_QUIRK_IGNORE_DUPLICATES so that any device can rely on it
>> * easier understandable support of hovering devices
>> * changed scan time definition
>> * applied new definition of scan time in hid-multitouch
>> * some other few things.
>
> Benjamin,
>
> thanks for the patchset.
>
> I am fine with the HID-specific changes (and I have sent out my Acks to
> the invidivual patches).

Thanks :)

>
> For hid-multitouch changes, I'd like to have Reviewed-by: from Henrik as
> well. Henrik, are you planning to review this patchset, please?
>
> Also the note from Dmitry on turning ABS_SCAN_TIME into
> EV_MSC/MSC_TIMESTAMP should be addressed.

Yes, sure. I'll do it today.

>
> Once this is finalized, I'd like to queue this for 3.8 in my tree.

Thanks,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
