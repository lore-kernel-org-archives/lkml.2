Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1JLWiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:38:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54902 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1JLWit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:38:49 -0400
Date: Thu, 13 Oct 2011 00:38:37 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20111012223836.GA29740@aftab>
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
 <4E94E1E5.4070505@goop.org>
 <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <4E96146C.5070701@goop.org>
 <4E9614AE.1060508@zytor.com>
 <4E9615B8.6010507@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9615B8.6010507@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:33:28PM -0400, Jeremy Fitzhardinge wrote:
> On 10/12/2011 03:29 PM, H. Peter Anvin wrote:
> > On 10/12/2011 03:27 PM, Jeremy Fitzhardinge wrote:
> >>
> >> The current scheme has worked pretty well so far; there doesn't seem to
> >> be a huge concern about it.  Have there been actual observed failures
> >> with the current mechanism, or is the drive to make it earlier driven by
> >> an aesthetic desire to make it "as it should be"?
> >>
> >
> > Yes, there has.  There is at least one case where we have to print an
> > error message saying "update your BIOS" because our current microcode
> > update is too late.
> 
> Is that K8 errata 93 or something else?

AFAIR, that was an Atom erratum fix.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
