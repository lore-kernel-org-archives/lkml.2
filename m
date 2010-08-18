Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0HRSqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:46:01 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53244 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0HRSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:46:00 -0400
Date: Wed, 18 Aug 2010 20:45:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100818184534.GA12842@aftab>
References: <4C69D02F.6090601@zytor.com>
 <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
 <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
 <20100818161639.GF9880@aftab>
 <4C6C08EC.2080404@zytor.com>
 <20100818173401.GG9880@aftab>
 <1282153895.15158.45.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282153895.15158.45.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok Kataria <akataria@vmware.com>
Date: Wed, Aug 18, 2010 at 01:51:35PM -0400

Hi,

> Thanks for doing this. I already had a patch ready doing just this,

sorry if I have caused any conflicts with your patch.

> though this change looks much nicer since you have moved all the code
> to the amd file. Guess I just have to wait for you to do the noop
> stuff if you are doing that. Once the patch is completed I can then
> just initialize this func ptr to the noop routine when on VMware's
> platform.

yeah, actually I was on the verge of completely removing that
calibrate_cpu code since maybe 99% of the systems out there should have
a TSC counting with the P0 rate so the issue becomes moot and no need
for fixing. But according to Murphy, there'll be this one system which
needs it and thus we have to keep it, unfortunately.

Anyway, I'll keep you posted.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
