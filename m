Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2FVC4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 22:56:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54329 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761025Ab2FVC4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 22:56:35 -0400
Date: Fri, 22 Jun 2012 04:56:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120622025631.GD29505@aftab.osrc.amd.com>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <4FE26155.8030207@zytor.com>
 <20120621100721.GB6437@aftab.osrc.amd.com>
 <4FE3ADDF.2060908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE3ADDF.2060908@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 04:27:27PM -0700, H. Peter Anvin wrote:
> On 06/21/2012 03:07 AM, Borislav Petkov wrote:
> > 
> > And if we need additional tools like to strip some text files or
> > whatever, then the whole discussion about what distros distribute it how
> > and what own patches they apply on the tool, etc, etc, starts.
> > 
> 
> That is orthogonal.  Anyway, my only concern about the request_firmware
> interface is that the timing will be inherently wrong.

Timing? Please elaborate.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
