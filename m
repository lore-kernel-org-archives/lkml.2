Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HIOvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:51:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45982 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1HIOvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110809144326.GA10105@gere.osrc.amd.com>
References: <20110805170120.4a3fd14c@stein>
	<20110809144326.GA10105@gere.osrc.amd.com>
Date: Tue, 9 Aug 2011 10:51:23 -0400
Message-ID: <CACqU3MUq7BVLX_jSGuCSN__9GPTeTVy5VmWHnW8x=6rc-afUJA@mail.gmail.com>
Subject: Re: ehci post 3.0: new section mismatch of ehci_bios_handoff() to ehci_dmi_nohandoff_table
From: Arnaud Lacombe <lacombar@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-usb@vger.kernel.org,
        Anisse Astier <anisse@astier.eu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 9, 2011 at 10:43 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Fri, Aug 05, 2011 at 05:01:20PM +0200, Stefan Richter wrote:
>> Hi,
>>
>> commit 03c75362181b0b1d6a330e7cf8def10ba988dfbe "ehci: refactor pci quirk
>> to use standard dmi_check_system method" added a new section mismatch.  A
>> web search shows that there is already a fix for this from Arnaud.
>> https://patchwork.kernel.org/patch/996112/mbox/
>>
>> Unless I am looking at a wrong git tree, the fix is not committed yet.
>>
>> The section mismatch:
>>
>> WARNING: drivers/built-in.o(.devinit.text+0x2e37): Section mismatch in
>> reference from the function ehci_bios_handoff() to the
>> variable .init.rodata:ehci_dmi_nohandoff_table
>> The function __devinit ehci_bios_handoff() references
>> a variable __initconst ehci_dmi_nohandoff_table.
>> If ehci_dmi_nohandoff_table is only used by ehci_bios_handoff then
>> annotate ehci_dmi_nohandoff_table with a matching annotation.
>
> Same here on -rc1 :(.
>
> Can someone please pick up the fix already? Greg?
>
greg added my patch to his usb tree yesterday.

 - Arnaud

> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> GM: Alberto Bozzo
> Reg: Dornach, Landkreis Muenchen
> HRB Nr. 43632 WEEE Registernr: 129 19551
>
