Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0KKLE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:04:56 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:23511
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754305Ab0KKLEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:04:54 -0500
X-SpamScore: -39
X-BigFish: VPS-39(z21eRzbb2cK1432N98dN1419Mzz1202hzz15d4Rz32i2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp02.amd.com;RD:ausb3extmailp02.amd.com;EFVD:NLI
X-WSS-ID: 0LBPW3P-01-7U5-02
X-M-MSG: 
Date: Thu, 11 Nov 2010 12:06:42 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Borislav Petkov <bp@amd64.org>
CC: Andrew Lutomirski <luto@mit.edu>, Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Subject: Re: [FALSE ALARM] Re: HPET (?) related hangs and breakage in
 2.6.35,36
Message-ID: <20101111110642.GN8917@amd.com>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de>
 <20101109153805.GB3146@kryptos.osrc.amd.com>
 <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
 <20101109180123.GB31121@aftab>
 <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com>
 <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com>
 <20101110185031.GB13539@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101110185031.GB13539@aftab>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:50:31PM -0500, Borislav Petkov wrote:
> On Wed, Nov 10, 2010 at 01:48:00PM -0500, Andrew Lutomirski wrote:
> > > Clocksource: tsc unstable (delta = -34355296774 ns)
> > > Switching: to clocksource hpet
> > 
> > Please disregard -- this is a bug in nouveau (or drm) not hpet.  I'll
> > send a bug report to the maintainers.
> 
> Interesting! Joerg was complaining about similar symptoms with .36 today
> too.

The issue I have seen was on two boxes with 890FX chipset and Phenom II
X6 CPUs on a recent avi/master which was 2.6.36 + some kvm patches.

The problem was that the box became extremly sluggish and slow. I stated
dstat and it reported a lot of missed ticks. After some time the
clocksource tsc became unstable and the system became responsive again.
I have not yet investigated this further but can do any requested tests.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

