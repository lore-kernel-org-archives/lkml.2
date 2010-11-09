Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0KIPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:37:55 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:14936
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab0KIPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:37:54 -0500
X-SpamScore: -31
X-BigFish: VPS-31(z21eRz146fK1432N98dNzz1202h1082kzz8275dh15d4Rz32i2a8h637h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LBMJEO-02-88V-02
X-M-MSG: 
Date: Tue, 9 Nov 2010 16:38:05 +0100
From: Borislav Petkov <bp@amd64.org>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Andrew Lutomirski <luto@mit.edu>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Subject: Re: HPET (?) related hangs and breakage in 2.6.35,36
Message-ID: <20101109153805.GB3146@kryptos.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@amd64.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4CD966D8.4000602@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 04:20:56PM +0100, Clemens Ladisch wrote:
> Andrew Lutomirski wrote:
> > After several minutes of uptime, my system freezes in a strange way.
> > All of userspace and some kernel services freeze hard (no mouse, no
> > typing, etc.)  Caps-lock works intermittently, as does (I think)
> > pinging.  The only debug output I've been able to get is this (typed
> > from a blurry photo because netconsole dies along with everything
> > else):
> > 
> > [ 5478.244722] Clocksource tsc unstable (delta = 101399051316 ns)
> > [ 5478.367958] Switching to clocksource hpet
> > [ 5543.729698] BUG: soft lockup - CPU #1 stuck for 61s! [migration/1:6]
> 
> Looks like this one:
> http://lkml.org/lkml/2010/10/26/126

I don't think so: the one at the URL above is 37-rc1 specific (issue
came in during the merge window) while Andrew's problem can be
reproduced with 35 and 36, reportedly.

Anyway, adding more people to Cc.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

