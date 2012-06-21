Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2FUKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:07:25 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51306 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab2FUKHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:07:24 -0400
Date: Thu, 21 Jun 2012 12:07:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120621100721.GB6437@aftab.osrc.amd.com>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <4FE26155.8030207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE26155.8030207@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 04:48:37PM -0700, H. Peter Anvin wrote:
> I really don't get why the whole thing is any simpler than the old
> /dev/cpu/microcode interface in the first place, where instead of:
> 
> > 1. put the blob in /lib/firmware/...
> > 2. echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> ... you do ...
> 
> 1. dd if=<microcode blob> of=/dev/cpu/microcode bs=<large>

Ok, this is more complex to the normal user than doing "echo 1 >.. "

And "echo 1 >.. " is the best and simplest we can do, and without any
tools needed to do the job - just the shell.

And if we need additional tools like to strip some text files or
whatever, then the whole discussion about what distros distribute it how
and what own patches they apply on the tool, etc, etc, starts.

> ... as well as set up the early initramfs part, of course.

Yeah, we all agree on that.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
