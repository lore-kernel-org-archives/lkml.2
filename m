Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0FAV4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:56:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40436 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0FAV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b6effCkbIymDruF/XzLWnoV9yApzLhI522PMxC5/StH9TKGrU3EWivM7k0z3gkCQRU
         +DQB/3g/8Ij0g798+7OCrPk5wZSohcu/T8ZzdEFEbxNa4EcXOW3tCm5d39uqbiszipFX
         F1c5d5KUjbZeP6X0nmQRe1UlxC+Cwj2TnPQr0=
Message-ID: <4C058205.7050707@gmail.com>
Date: Tue, 01 Jun 2010 14:56:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org> <4C056E0C.2030709@gmail.com> <20100601203351.GA16575@srcf.ucam.org> <4C0572B4.6000201@gmail.com> <20100601211219.GA17719@srcf.ucam.org> <4C057AE9.9020307@gmail.com> <20100601212901.GA18390@srcf.ucam.org> <4C057EF0.2030808@gmail.com> <20100601214820.GB18864@srcf.ucam.org>
In-Reply-To: <20100601214820.GB18864@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 02:48 PM, Matthew Garrett wrote:
> On Tue, Jun 01, 2010 at 02:43:12PM -0700, Justin P. Mattock wrote:
>> On 06/01/2010 02:29 PM, Matthew Garrett wrote:
>>> So, just to be clear, you run this as root and it immediately returns
>>> you to the prompt? This seems unlikely.
>>
>> yep.. with the above code
>> I (save to a file) then
>> non-root gcc reboot.c -o reboot
>> then su
>> ./reboot
>> just bake to the command prompt
>
> Are you running some sort of security policy that might block hardware
> access? I'm going to have to find one of these machines to test with -
> on everything I have here, the cf9 write and the keyboard controller
> write both generate reboots. The worst case should be a hung machine,
> not one that continues running...
>


yeah I just checked
/usr/sbin/sestatus has everything in permissive
mode. as for the system it's fedora 13

as for testing on this machine
if your in Ventura county let me know

Justin P. Mattock
