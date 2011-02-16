Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab1BPJy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:54:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46454 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843Ab1BPJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:54:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JWzO+0EneJztlol6sLUqUCEWOcwfg9RzPgEnGeUjYuR6ybDKs67cMJ6gLK+4gpbrmu
         Gl/Kmk1B7cC6qsu8PMLd3uCR6AKdbKF9rHzYs15RW4ThZYDTfWmq+zz/pn+JB4yuaWCC
         MIOajZxyL8oeyvs4zIXOzdcGAMvp26vmhtb7Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1102160003420.2160@pobox.suse.cz>
References: <1297780428-3805-1-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1102160003420.2160@pobox.suse.cz>
Date: Wed, 16 Feb 2011 10:54:24 +0100
X-Google-Sender-Auth: Gv4vOCDSDuFoKoHZvReCGTUC0BI
Message-ID: <AANLkTi=QF-9QtGK8V795R9ZO4-c6sQ8MSTW+JMxwd2+d@mail.gmail.com>
Subject: Re: [PATCH] HID: add IRTOUCH infrared USB to hid_have_special_driver
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Thanks for applying those two patches.
BTW I'm a little worried: apparently you applied this patch in the
branch upstream-fixes but you didn't applied "HID: hid-multitouch:
introduce IrTouch Infrared USB..." and it's parents in this branch....
I'm afraid this will broke compilation of the upstream branch
(USB_VENDOR_ID_IRTOUCHSYSTEMS and USB_DEVICE_ID_IRTOUCH_INFRARED_USB
are not defined).

Thanks,
Benjamin

On Wed, Feb 16, 2011 at 00:04, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 15 Feb 2011, Benjamin Tissoires wrote:
>
>> Without this patch, the device is handled by hidinput and does
>> not have the right behavior.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>> Hi guys,
>>
>> In the previous patch including the support to IRTOUCH devices, I forgot
>> to add it to hid_have_special_driver. Sorry.
>
> Hmm, this happens quite often to people submitting patches, but I normally
> catch it. This time my eyes have failed.
>
> Thanks for the fix, applied.
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>
