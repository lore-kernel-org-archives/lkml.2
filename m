Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1JMHBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:01:04 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45041 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1JMHBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:01:03 -0400
Date: Thu, 13 Oct 2011 09:00:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20111013070050.GA501@aftab>
References: <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
 <20111012214013.GD28723@aftab>
 <4E96198F.4030906@zytor.com>
 <4E962581.2000605@goop.org>
 <4E9628D4.1000605@zytor.com>
 <4E962A27.4090509@goop.org>
 <4E962AE6.1060505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E962AE6.1060505@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:03:50PM -0400, H. Peter Anvin wrote:
> On 10/12/2011 05:00 PM, Jeremy Fitzhardinge wrote:
> >
> > Presumably we'd want some way to make all possible microcode files
> > available to the hypervisor/kernel so that there's no need to construct
> > the bootloader config for a specific CPU vendor (or worse, CPU model).
> > So that would need either some way of specifying multiple files, or a
> > wrapper which can contain multiple files?
> >
> 
> I have been thinking a "bundle" format with a per-vendor header followed 
> by the microcode in the appropriate format for each vendor.

Yes, makes sense. Keep it as simple as possible.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
