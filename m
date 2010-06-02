Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0FBFLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:11:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0FBFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=seVH1sSX7vYhtmrgCAdZpxLbsSF4pHEyDB6Cx5jcLLA5+DzADwyEH9WkbEPxL5mLaj
         Bs3VmqlxEKqdgw8UE7r3oDDtGKFIpnhkhwJtolTX0bmmSgqla9LlIarWH4HClwc5r+yM
         /92EO06Ek20r0qZBrc2H1YjPqQ2xjuAVK6XzA=
Message-ID: <4C05E800.1010400@gmail.com>
Date: Tue, 01 Jun 2010 23:11:28 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org> <4C056E0C.2030709@gmail.com> <20100601203351.GA16575@srcf.ucam.org> <4C0572B4.6000201@gmail.com> <20100601211219.GA17719@srcf.ucam.org> <4C057AE9.9020307@gmail.com> <20100601212901.GA18390@srcf.ucam.org> <4C057EF0.2030808@gmail.com>
In-Reply-To: <4C057EF0.2030808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 03:43 PM, Justin P. Mattock wrote:
> On 06/01/2010 02:29 PM, Matthew Garrett wrote:
>> On Tue, Jun 01, 2010 at 02:26:01PM -0700, Justin P. Mattock wrote:
>>> On 06/01/2010 02:12 PM, Matthew Garrett wrote:
>>>> some level. How about the following (again, run as root):
>>>>
>>>> #include<sys/io.h>
>>>>
>>>> int main() {
>>>> iopl(3);
>>>> outb(0xfe, 0x64);
>>>> return 0;
>>>> }
>>>>
>>
>> So, just to be clear, you run this as root and it immediately returns
>> you to the prompt? This seems unlikely.
>
> yep.. with the above code
> I (save to a file) then
> non-root gcc reboot.c -o reboot
> then su
> ./reboot
> just bake to the command prompt

Can you post the FACP section of the acpidump output from this machine?

>
>>
>>> ahh!! I see now:
>>> grep 0x64 *.dsl
>>
>> No, that's unrelated.
>>
>
> alright!!
>
> Justin P. Mattock

