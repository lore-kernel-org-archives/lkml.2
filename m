Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab0FCCQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:16:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45594 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab0FCCQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BuR9Nco/AuEzNm/Vic0QcufMtjQ/UaIzNhBQYYJO/8klai22WHLdIQkczWKDZauTgZ
         Ps4F0kVDnjY8a6uwvqKju1mQC2y02PdsxiECZ01FyJRoIb4yuxJetDlZ2w+qd0r4Tz6W
         EI0P5SdIc8Z70H9uj+n08XD5QpjQRw0yR2f8k=
Message-ID: <4C07107A.8070602@gmail.com>
Date: Wed, 02 Jun 2010 19:16:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <20100601212901.GA18390@srcf.ucam.org>	<4C057EF0.2030808@gmail.com>	<4C05E800.1010400@gmail.com>	<4C05F3BF.6090503@gmail.com>	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>	<4C06ECAA.3060708@gmail.com>	<4C06ED18.2010400@gmail.com>	<4C06F1DD.8060004@gmail.com>	<AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>	<4C06F6EA.6090701@gmail.com>	<20100603013758.GA18755@srcf.ucam.org>	<AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>	<4C070CB4.2030304@gmail.com> <AANLkTimADCKDJkcAnHQ6uN9vzTWJixB0Dk1YVO8LdI7W@mail.gmail.com>
In-Reply-To: <AANLkTimADCKDJkcAnHQ6uN9vzTWJixB0Dk1YVO8LdI7W@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 07:05 PM, Robert Hancock wrote:
> On Wed, Jun 2, 2010 at 8:00 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 06/02/2010 06:47 PM, Robert Hancock wrote:
>>>
>>> On Wed, Jun 2, 2010 at 7:37 PM, Matthew Garrett<mjg59@srcf.ucam.org>
>>>   wrote:
>>>>
>>>> On Wed, Jun 02, 2010 at 05:27:22PM -0700, Justin P. Mattock wrote:
>>>>>
>>>>> On 06/02/2010 05:20 PM, Robert Hancock wrote:
>>>>>>
>>>>>> #include<unistd.h>
>>>>>>
>>>>>> int main() {
>>>>>>           iopl(3);
>>>>>>           outb(2, 0xcf9);
>>>>>>           sleep(1);
>>>>>>           outb(6, 0xcf9);
>>>>>>           return 0;
>>>>>> }
>>>>>>
>>>>>> That's basically what PCI reboot does.
>>>>>
>>>>> the above code reboot's the machine as it should..
>>>>> I can look at that(need to take a break first though)
>>>>> and see..
>>>>
>>>> That's pretty infuriating. The ACPI-provided definition doesn't work,
>>>> and there's no ACPI mechanism for expressing the more complex cf9
>>>> behaviour. Windows doesn't appear to special case this, so we're
>>>> probably left trying to figure out why the keyboard controller method
>>>> doesn't work. Sigh.
>>>
>>> Do these Macs even have a PC keyboard controller? A recent thread on
>>> PS/2 keyboard/mouse controller probing suggests they may not..
>>>
>>> Justin, what happens if you try the simple outb(6, 0xcf9) test program
>>> multiple times, does that do anything?
>>>
>>
>>
>> this reboots the system
>>
>>
>> int main() {
>>            iopl(3);
>>            outb(6, 0xcf9);
>>            return 0;
>> }
>
> On a single try, or multiple times? (You tried that one before once
> and it didn't work, right?)
>

yeah single try. then I rebooted
and it was like dead or something.

Justin P. Mattock
