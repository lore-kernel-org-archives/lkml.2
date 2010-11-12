Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab0KLNsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:48:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0KLNsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iuMmX6T1iYBM4vpwOkgay75cZDf+sMQpTzUyNvwb++5gCsd0pAxAuMQZixYdcp6jJr
         zLbPZwfm3ryGZc4U6y6xgsVW5kty/BxotNZ+UIN8c9O3MNvJdosexqK8dxMtf2PS+rfz
         9YGBmodfQcrsSLWsU3yKaSj6fWDwVy1YOZ2j4=
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F069@dbde02.ent.ti.com>
References: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F05C@dbde02.ent.ti.com>
	<AANLkTin-j1Aww+Nu4zRdAP5TH-t+ftpW6VEWUdejb1Pn@mail.gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F069@dbde02.ent.ti.com>
Date: Fri, 12 Nov 2010 15:48:19 +0200
Message-ID: <AANLkTikd51vvT+=1TUU08s8Pxo7oNBX415=rnQEf6Wtv@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> -----Original Message-----
>> From: Andrei Emeltchenko [mailto:andrei.emeltchenko.news@gmail.com]
>> Sent: Friday, November 12, 2010 6:50 PM
>> To: G, Manjunath Kondaiah
>> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-arm@lists.arm.linux.org.uk; linux-serial@vger.kernel.org
>> Subject: Re: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
>>
>> On Fri, Nov 12, 2010 at 3:17 PM, G, Manjunath Kondaiah
>> <manjugk@ti.com> wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: linux-omap-owner@vger.kernel.org
>> >> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of
>> >> Emeltchenko Andrei
>> >> Sent: Friday, November 12, 2010 6:34 PM
>> >> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
>> >> linux-arm@lists.arm.linux.org.uk; linux-serial@vger.kernel.org
>> >> Subject: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
>> >
>> > s/diplicates/duplicates
>> >
>> >>
>> >> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>> >>
>> >> Add MDR1 Serial register definition to serial_reg and remove
>> >> duplicated
>> >> code, remove magic MDR1 register numbers from serial drivers.
>> >>
>> >> *v2 add OMAP keyword to MDR1 definition
>> >> *v3 remove magic from serial drivers
>> >> *v4 taking comments from Manjunath and Govindraj: typos, CC
>> >>
>> >> Andrei Emeltchenko (4):
>> >>   OMAP: Serial: Define OMAP uart MDR1 register definitions
>> >>   OMAP1: Serial: remove magic numbers for MDR1 reg
>> >>   OMAP2: Serial: remove magic numbers for MDR1 reg
>> >>   OMAP: Serial: remove redefined MDR1 register definitions
>> >>
>> >>  arch/arm/mach-omap1/serial.c                  |    6 ++++--
>> >>  arch/arm/mach-omap2/serial.c                  |   15
>> +++++++++------
>> >>  arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
>> >>  drivers/serial/omap-serial.c                  |    6 +++---
>> >>  include/linux/serial_reg.h                    |   12 ++++++++++++
>> >>  5 files changed, 28 insertions(+), 14 deletions(-)
>> >
>> > Do you think patch series is required for these changes? How about
>> > merging with single patch?
>>
>> I can merge, sometimes somebody need patches to be split,
>
> why? can you give example?

Maybe I got it wrong.

> Please read: http://lwn.net/Articles/139918/
> "if you make a single change to numerous files, group those changes into
> a single patch.  Thus a single logical change is contained within a
> single patch."

I have squashed those patches to the single one.

Regards,
Andrei
