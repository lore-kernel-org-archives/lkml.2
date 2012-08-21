Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab2HUUta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:49:30 -0400
Received: from mail.x86-64.org ([217.9.48.20]:33665 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405Ab2HUUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:49:09 -0400
Date: Tue, 21 Aug 2012 22:48:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Message-ID: <20120821204858.GA30472@aftab.osrc.amd.com>
References: <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
 <503078A2.9030204@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
 <20120820140630.GD24149@aftab.osrc.amd.com>
 <50329951.9030805@zytor.com>
 <20120820201947.GC15006@aftab.osrc.amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712200778846C@ORSMSX105.amr.corp.intel.com>
 <5033EBE6.5080608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5033EBE6.5080608@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 01:13:26PM -0700, H. Peter Anvin wrote:
> I don't know what Borislav was suggesting with "BIOS overrides", is
> that another CPU-specific thing?

Not CPU- but rather platform-specific. It is Thomas Renninger's
mechanism to override BIOS tables.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
