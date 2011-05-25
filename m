Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1EYVIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:08:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36080 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1EYVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:08:16 -0400
Date: Wed, 25 May 2011 23:08:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        Andi Kleen <andi@firstfloor.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525210802.GC16110@aftab>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
 <20110525080042.GA27183@liondog.tnic>
 <20110525090501.GA28500@elte.hu>
 <20110525105057.GA21830@gere.osrc.amd.com>
 <20110525112852.GD30983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525112852.GD30983@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 07:28:52AM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > Btw, can we dump the ucode version in hex since ours are much easier to
> > read that way:
> > 
> > [86483.770976] microcode: CPU0: patch_level=0x010000c4
> > [86483.826987] microcode: CPU1: patch_level=0x010000c4
> > [86483.835071] microcode: CPU2: patch_level=0x010000c4
> > ...
> 
> How is that version constructed and iterated, or example is the 
> 0x01000000 bit always set?
> 
> If it's always set then it might make sense to turn this into a more 
> human-readable version number: mask out the 0x01000000 and report 
> 0xc4 as 194? Or is the *real* version above just '4'?
> 
> Should 0x010000c4 perhaps be printed as 1.10.4?

Nah, splitting this doesn't give you any information we could use,
besides this format is the only format our ucode nomenclature uses so
having it different in Linux might cause confusion.

> 
> > I guess for Intel the ucode version format won't matter that much.
> 
> Well, if Intel does similar encodings as AMD,

I hardly doubt that.

> then it would be nice to turn that into human-readable version strings
> as well.

I think leaving it as a hex number would fit both vendors adequately.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
