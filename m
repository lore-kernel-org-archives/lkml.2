Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2HUUPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:15:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab2HUUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:14:11 -0400
Message-ID: <5033EBE6.5080608@zytor.com>
Date: Tue, 21 Aug 2012 13:13:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com> <1345277729-8399-5-git-send-email-fenghua.yu@intel.com> <20120818224442.GB32120@khazad-dum.debian.net> <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com> <503078A2.9030204@zytor.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com> <20120820140630.GD24149@aftab.osrc.amd.com> <50329951.9030805@zytor.com> <20120820201947.GC15006@aftab.osrc.amd.com> <3E5A0FA7E9CA944F9D5414FEC6C712200778846C@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712200778846C@ORSMSX105.amr.corp.intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 01:05 PM, Yu, Fenghua wrote:
> 
> We might name the cpio directory as:
> 
> kernel/x86/microcode/GenuineIntel.bin
> kernel/x86/microcode/AuthenticAMD.bin
> kernel/x86/acpi/...
> etc.
> 
> This is expendable for the future usage.
>  
> Plus I will add a doc on the cpio directory, supported directory names and how to add new stuffs in the directory.
> 

I believe that was exactly my original proposal.  I think it makes
sense... most things aren't going to be inherently CPU-specific in this way.

I don't know what Borislav was suggesting with "BIOS overrides", is that
another CPU-specific thing?

	-hpa

