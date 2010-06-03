Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab0FCBrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:47:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab0FCBrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TJmatc/PEuthh48CYIl03pt0R2gL2Tt8liSIswDJvqdC/cEvNUcDfs94LWFUj5mxgm
         UVBzn6V/DJdllQGIF+dYPpxIPEN69JpujPbrXQy9vxjIucvQy3XBO7r0LBL+pOehsug2
         7UOaInaINS6NL8bPlp5ssgeHIhF28wFP3zjp8=
MIME-Version: 1.0
In-Reply-To: <20100603013758.GA18755@srcf.ucam.org>
References: <20100601212901.GA18390@srcf.ucam.org>
	<4C057EF0.2030808@gmail.com>
	<4C05E800.1010400@gmail.com>
	<4C05F3BF.6090503@gmail.com>
	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>
	<4C06ECAA.3060708@gmail.com>
	<4C06ED18.2010400@gmail.com>
	<4C06F1DD.8060004@gmail.com>
	<AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>
	<4C06F6EA.6090701@gmail.com>
	<20100603013758.GA18755@srcf.ucam.org>
Date: Wed, 2 Jun 2010 19:47:17 -0600
Message-ID: <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
From: Robert Hancock <hancockrwd@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 7:37 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jun 02, 2010 at 05:27:22PM -0700, Justin P. Mattock wrote:
>> On 06/02/2010 05:20 PM, Robert Hancock wrote:
>>> #include<unistd.h>
>>>
>>> int main() {
>>>          iopl(3);
>>>          outb(2, 0xcf9);
>>>          sleep(1);
>>>          outb(6, 0xcf9);
>>>          return 0;
>>> }
>>>
>>> That's basically what PCI reboot does.
>>
>> the above code reboot's the machine as it should..
>> I can look at that(need to take a break first though)
>> and see..
>
> That's pretty infuriating. The ACPI-provided definition doesn't work,
> and there's no ACPI mechanism for expressing the more complex cf9
> behaviour. Windows doesn't appear to special case this, so we're
> probably left trying to figure out why the keyboard controller method
> doesn't work. Sigh.

Do these Macs even have a PC keyboard controller? A recent thread on
PS/2 keyboard/mouse controller probing suggests they may not..

Justin, what happens if you try the simple outb(6, 0xcf9) test program
multiple times, does that do anything?
