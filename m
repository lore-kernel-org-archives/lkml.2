Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab0FCCFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:05:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51512 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549Ab0FCCFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IDMaQMHAU0cLmmI3xXaX2soj2wfmjM3/1L/l6hlm2gmpw7hab+iG0Kuyu+MlDg0qan
         ffjBROOI4MMOGUGFceVd57ohtZDlkYGQkkUDZCd5Uz5PzbDO1qHeA4YW84QSwJ8bdPr2
         3RErynB8vfl3NAxQcsisCjAhbjh9oD080Dh38=
MIME-Version: 1.0
In-Reply-To: <4C070CB4.2030304@gmail.com>
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
	<AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
	<4C070CB4.2030304@gmail.com>
Date: Wed, 2 Jun 2010 20:05:29 -0600
Message-ID: <AANLkTimADCKDJkcAnHQ6uN9vzTWJixB0Dk1YVO8LdI7W@mail.gmail.com>
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
From: Robert Hancock <hancockrwd@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 8:00 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 06/02/2010 06:47 PM, Robert Hancock wrote:
>>
>> On Wed, Jun 2, 2010 at 7:37 PM, Matthew Garrett<mjg59@srcf.ucam.org>
>>  wrote:
>>>
>>> On Wed, Jun 02, 2010 at 05:27:22PM -0700, Justin P. Mattock wrote:
>>>>
>>>> On 06/02/2010 05:20 PM, Robert Hancock wrote:
>>>>>
>>>>> #include<unistd.h>
>>>>>
>>>>> int main() {
>>>>>          iopl(3);
>>>>>          outb(2, 0xcf9);
>>>>>          sleep(1);
>>>>>          outb(6, 0xcf9);
>>>>>          return 0;
>>>>> }
>>>>>
>>>>> That's basically what PCI reboot does.
>>>>
>>>> the above code reboot's the machine as it should..
>>>> I can look at that(need to take a break first though)
>>>> and see..
>>>
>>> That's pretty infuriating. The ACPI-provided definition doesn't work,
>>> and there's no ACPI mechanism for expressing the more complex cf9
>>> behaviour. Windows doesn't appear to special case this, so we're
>>> probably left trying to figure out why the keyboard controller method
>>> doesn't work. Sigh.
>>
>> Do these Macs even have a PC keyboard controller? A recent thread on
>> PS/2 keyboard/mouse controller probing suggests they may not..
>>
>> Justin, what happens if you try the simple outb(6, 0xcf9) test program
>> multiple times, does that do anything?
>>
>
>
> this reboots the system
>
>
> int main() {
>           iopl(3);
>           outb(6, 0xcf9);
>           return 0;
> }

On a single try, or multiple times? (You tried that one before once
and it didn't work, right?)
