Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1AKPH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:07:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1AKPHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:07:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RfMB9BcmhERNNiN4Iiryhl5dfqSDNwM9Tzqi2GnERq53jG0elOKVeA0sC68wf43GTf
         sSXK4nSCeBlo5MK4I5J+AjeHtCYeaty0Bh9fqBrefSZIoejD4uaZtH5n1r5jT13CVJ5q
         HU+GlPKrogypBEgyTY0+Sb/6FGI4ce/OaG52E=
MIME-Version: 1.0
In-Reply-To: <AANLkTimESwHSh-LMdAnb20Ss3OxW=gpTaN0QdTSfEx33@mail.gmail.com>
References: <1294743194-2310-1-git-send-email-benjamin.tissoires@enac.fr>
	<20110111131154.GC1961@polaris.bitmath.org>
	<AANLkTimESwHSh-LMdAnb20Ss3OxW=gpTaN0QdTSfEx33@mail.gmail.com>
Date: Tue, 11 Jan 2011 16:07:23 +0100
X-Google-Sender-Auth: LhK2XPrYvkEYPsH-Ink04afIgpI
Message-ID: <AANLkTinzuvULWvdaptpSUc2kYtGY2C8xOD34TQdjt6JU@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: changes from the review process
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 3:00 PM, Benjamin Tissoires
<benjamin.tissoires@enac.fr> wrote:
> On Tue, Jan 11, 2011 at 2:11 PM, Henrik Rydberg <rydberg@bitmath.org> wrote:
>> [...]
>>> +             .sn_move = 0,
>>> +             .sn_pressure = 0,
>>> +             .maxcontacts = 10 },
>>> +     { .name = MT_CLS_DUAL1,
>>> +             .quirks = MT_QUIRK_SLOT_IS_CONTACTID,
>>> +             .sn_move = 0,
>>> +             .sn_pressure = 0,
>>> +             .maxcontacts = 2 },
>>> +     { .name = MT_CLS_DUAL2,
>>> +             .quirks = MT_QUIRK_SLOT_IS_CONTACTNUMBER,
>>> +             .sn_move = 0,
>>> +             .sn_pressure = 0,
>>> +             .maxcontacts = 2 },
>>> +     { .name = MT_CLS_CYPRESS,
>>> +             .quirks = MT_QUIRK_CYPRESS,
>>> +             .sn_move = 0,
>>> +             .sn_pressure = 0,
>>> +             .maxcontacts = 10 },
>>> +
>>> +     { }
>>>  };
>>
>> So no device is marked as NOT_SEEN_MEANS_UP, although allegedly some devices should...
>
> Well, my fault: I was sure that Cypress devices need the
> NOT_SEEN_MEANS_UP, but in fact, it was another one. We (with Stephane)
> don't recall it at the moment, but Stephane already saw some devices
> that required this quirk.
>
> mea culpa

I was neither wrong, neither right:
For cypress, TipSwitch, Confidence, and InRange always are the same... ;)
-> I'll need to put them with the quirk MT_NOT_SEEN_MEANS_UP

Cheers,
Benjamin
>
>>
>>[...]
