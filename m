Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1HIOnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:43:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42858 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1HIOnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:43:10 -0400
Date: Tue, 9 Aug 2011 16:43:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-usb@vger.kernel.org, Anisse Astier <anisse@astier.eu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ehci post 3.0: new section mismatch of ehci_bios_handoff() to
 ehci_dmi_nohandoff_table
Message-ID: <20110809144326.GA10105@gere.osrc.amd.com>
References: <20110805170120.4a3fd14c@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805170120.4a3fd14c@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 05:01:20PM +0200, Stefan Richter wrote:
> Hi,
> 
> commit 03c75362181b0b1d6a330e7cf8def10ba988dfbe "ehci: refactor pci quirk
> to use standard dmi_check_system method" added a new section mismatch.  A
> web search shows that there is already a fix for this from Arnaud.
> https://patchwork.kernel.org/patch/996112/mbox/
> 
> Unless I am looking at a wrong git tree, the fix is not committed yet.
> 
> The section mismatch:
> 
> WARNING: drivers/built-in.o(.devinit.text+0x2e37): Section mismatch in
> reference from the function ehci_bios_handoff() to the
> variable .init.rodata:ehci_dmi_nohandoff_table
> The function __devinit ehci_bios_handoff() references
> a variable __initconst ehci_dmi_nohandoff_table.
> If ehci_dmi_nohandoff_table is only used by ehci_bios_handoff then
> annotate ehci_dmi_nohandoff_table with a matching annotation.

Same here on -rc1 :(.

Can someone please pick up the fix already? Greg?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
