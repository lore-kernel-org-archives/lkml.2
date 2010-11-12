Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0KLNUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:20:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0KLNUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qEzLbPZ5O51yVnzoYF8t7ADpuKqQb0JtYs77AUuSnEfsRg8WeGL5pw0SqKnAOE3TUr
         MEVnHKCNOMIaA28G8s2KtAL+vvniggiB65HpHK5nEW95UXRP5cMLpD49nVFl6auIIMlD
         umFE4eRpK8/iEaCaskOEQDMqctqzTSQcf4dXg=
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F05C@dbde02.ent.ti.com>
References: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F05C@dbde02.ent.ti.com>
Date: Fri, 12 Nov 2010 15:20:07 +0200
Message-ID: <AANLkTin-j1Aww+Nu4zRdAP5TH-t+ftpW6VEWUdejb1Pn@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 3:17 PM, G, Manjunath Kondaiah <manjugk@ti.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-omap-owner@vger.kernel.org
>> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of
>> Emeltchenko Andrei
>> Sent: Friday, November 12, 2010 6:34 PM
>> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-arm@lists.arm.linux.org.uk; linux-serial@vger.kernel.org
>> Subject: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
>
> s/diplicates/duplicates
>
>>
>> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>>
>> Add MDR1 Serial register definition to serial_reg and remove
>> duplicated
>> code, remove magic MDR1 register numbers from serial drivers.
>>
>> *v2 add OMAP keyword to MDR1 definition
>> *v3 remove magic from serial drivers
>> *v4 taking comments from Manjunath and Govindraj: typos, CC
>>
>> Andrei Emeltchenko (4):
>>   OMAP: Serial: Define OMAP uart MDR1 register definitions
>>   OMAP1: Serial: remove magic numbers for MDR1 reg
>>   OMAP2: Serial: remove magic numbers for MDR1 reg
>>   OMAP: Serial: remove redefined MDR1 register definitions
>>
>>  arch/arm/mach-omap1/serial.c                  |    6 ++++--
>>  arch/arm/mach-omap2/serial.c                  |   15 +++++++++------
>>  arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
>>  drivers/serial/omap-serial.c                  |    6 +++---
>>  include/linux/serial_reg.h                    |   12 ++++++++++++
>>  5 files changed, 28 insertions(+), 14 deletions(-)
>
> Do you think patch series is required for these changes? How about
> merging with single patch?

I can merge, sometimes somebody need patches to be split, merging is easy.

-- Andrei
