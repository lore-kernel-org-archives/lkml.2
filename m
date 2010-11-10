Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0KJSvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:51:36 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43099 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0KJSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:51:35 -0500
Date: Wed, 10 Nov 2010 19:50:31 +0100
From: Borislav Petkov <bp@amd64.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Subject: Re: [FALSE ALARM] Re: HPET (?) related hangs and breakage in
 2.6.35,36
Message-ID: <20101110185031.GB13539@aftab>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de>
 <20101109153805.GB3146@kryptos.osrc.amd.com>
 <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
 <20101109180123.GB31121@aftab>
 <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com>
 <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:48:00PM -0500, Andrew Lutomirski wrote:
> > Clocksource: tsc unstable (delta = -34355296774 ns)
> > Switching: to clocksource hpet
> 
> Please disregard -- this is a bug in nouveau (or drm) not hpet.  I'll
> send a bug report to the maintainers.

Interesting! Joerg was complaining about similar symptoms with .36 today
too.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
