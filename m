Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2HTUJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:09:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51046 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2HTUJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:09:31 -0400
Message-ID: <50329951.9030805@zytor.com>
Date: Mon, 20 Aug 2012 13:08:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com> <1345277729-8399-5-git-send-email-fenghua.yu@intel.com> <20120818224442.GB32120@khazad-dum.debian.net> <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com> <503078A2.9030204@zytor.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com> <20120820140630.GD24149@aftab.osrc.amd.com>
In-Reply-To: <20120820140630.GD24149@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 07:06 AM, Borislav Petkov wrote:
> 
> Or,
> 
> in case we want to supply more vendor-specific stuff early at boot, we
> could do:
> 
> kernel/x86/<vendor>/microcode...
> 		|-> bios_overrides
> 		|-> ...
> 
> and have this layout extensible from the beginning...
> 

Does that make sense, though?  I'm a bit concerned about having multiple
files named microcode.bin by default; the pathname isn't as sticky as
the filename when people move things around...

	-hpa
