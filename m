Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2FUJ6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:58:11 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51253 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab2FUJ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:58:09 -0400
Date: Thu, 21 Jun 2012 11:58:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120621095807.GA6437@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <1340267075.21745.155.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340267075.21745.155.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 10:24:35AM +0200, Peter Zijlstra wrote:
> This thing is not installed on my machine, nor would I have know
> to look for it. Nor does apt-cache search iucode_tool suggest any
> package.
>
> IOW fail.

FWIW, if we agree that we need a userspace tool for massaging Intel's
ucode, it should be in tools/ and it should be very easy to install even
on a distro which doesn't distribute it.

Emphasis on the initial "if", of course.

I'd very much prefer tool-less ucode application.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
