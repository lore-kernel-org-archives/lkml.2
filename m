Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1ALNBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:01:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab1ALNBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:01:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cO3mSpcZF95bdyIbBNF8cHIKuF3ZFrKlvQf9xeoqSwQawXNjPJWEeNatNwKIw8EJBt
         hMOSAatWTY6KLt5a/uOi4uTx3DGEgPI0FAwQ4lW8OSmC3pL+JK5ANEu2TA2etsStPIqh
         i4dL8r6aqa4RGfW83TnuFKg+R0YiSnuk3aCAY=
MIME-Version: 1.0
In-Reply-To: <20110112122741.GA29373@polaris.bitmath.org>
References: <1294760754-7885-1-git-send-email-benjamin.tissoires@enac.fr>
	<20110111173511.GA3461@polaris.bitmath.org>
	<AANLkTin86WMvEpNAm2T8wR=GgUBtYqoqGJxZm7hKnEoE@mail.gmail.com>
	<20110112122741.GA29373@polaris.bitmath.org>
Date: Wed, 12 Jan 2011 14:01:00 +0100
X-Google-Sender-Auth: kEwGwBk0Su5KGhmdDLyPwIygy3E
Message-ID: <AANLkTimnY3QC+7tsGhHi8awkMYQTDH8ugn4U--qkmup4@mail.gmail.com>
Subject: Re: [PATCH v2] hid-multitouch: changes from the review process
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

On Wed, Jan 12, 2011 at 1:27 PM, Henrik Rydberg <rydberg@bitmath.org> wrote:
> On Tue, Jan 11, 2011 at 06:38:24PM +0100, Benjamin Tissoires wrote:
>> On Tue, Jan 11, 2011 at 6:35 PM, Henrik Rydberg <rydberg@bitmath.org> wrote:
>> > On Tue, Jan 11, 2011 at 04:45:54PM +0100, Benjamin Tissoires wrote:
>> >> * amended Kconfig (PixCir and Hanvon are the same panel but with
>> >>   different name)
>> >> * insert field name in mt_class and retrieving it in mt_probe
>> >> * add 2 quirks: MT_QUIRK_VALID_IS_INRANGE, MT_QUIRK_VALID_IS_CONFIDENCE,
>> >>   in order to find the field "valid"
>> >> * inlined slot_is_contactid and slot_is_contact_number
>> >> * cosmetics changes (tabs and comments)
>> >> * do not send unnecessary properties once the touch is up
>> >>
>> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> >
>> > There are some syntactic suboptimalities in the resulting file that
>> > perhaps could be fixed, but content-wise, I have nothing further. So,
>> > given that it actually works,
>> >
>> > Acked-by: Henrik Rydberg <rydberg@euromail.se>
>> >
>> > Thank you very much for your work, Benjamin.
>>
>> Thanks for the review Henrik,
>
> Regarding the quanta patches you have pending, IFAICT the 0408:3001
> device is not properly supported currently, so perhaps that one could
> be added to the list, too.
>

Hi Henrik,

What do you mean by not properly supported?

the device is in hid-quanta since 2.6.33: commit "HID: add support for
Pixart Imaging Optical Touch Screen"

Cheers,
Benjamin
