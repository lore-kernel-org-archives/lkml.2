Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063Ab2FVDBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:01:06 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54343 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761028Ab2FVDBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:01:04 -0400
Date: Fri, 22 Jun 2012 05:01:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120622030101.GE29505@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <1340267075.21745.155.camel@twins>
 <20120621230059.GA27178@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621230059.GA27178@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 08:00:59PM -0300, Henrique de Moraes Holschuh wrote:
> Meh.  I uploaded the first public version of the thing a whole two weeks
> ago!  It should have been all over the Internet by now ;-)
> 
> It is in Debian Wheezy (soon-to-be-stable) as of yesterday, I think.  It
> will eventually end up in Ubuntu.  And if you guys think it is worthwhile to
> maintain it upstream either in git.k.o, or as part of tools/, I have nothing
> against it.
> 
> I posted the URL earlier, I think, but here it is:
> http://cdn.debian.net/debian/pool/contrib/i/iucode-tool/iucode-tool_0.8.orig.tar.bz2
> 
> But it really exists to help distros do Intel microcode management and
> release install-and-forget packages for end users.  End-users should get to
> either ignore its existence entirely and get automated updates of microcode
> as distro binary packages, or run an "update-intel-microcode" script (not
> written yet, but there is one on Debian and Ubuntu's microcode.ctl package)
> that downloads the blob from Intel, and does whatever is needed to install
> it to /lib/firmware and apply it to the running system (and kernel image,
> initramfs, whatever).

Yeah, this is all very helpful but let's see whether we are even going
to need a tool, at all. If we are tool-less, we don't depend on any
userspace stuff and ucode application just works like ftrace - no need
for a specific tool but the shell and debugfs (sysfs in our case).

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
