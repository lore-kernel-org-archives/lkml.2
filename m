Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1JLKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:16:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34382 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1JLKQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:16:28 -0400
Date: Wed, 12 Oct 2011 12:16:16 +0200
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
Message-ID: <20111012101615.GA14966@aftab>
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
 <4E94E1E5.4070505@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E94E1E5.4070505@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 08:40:05PM -0400, Jeremy Fitzhardinge wrote:
> Ping?
> 
> On 09/26/2011 11:17 AM, Jeremy Fitzhardinge wrote:
> > From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >
> > Hi all,
> >
> > I'm proposing this for the next merge window v3.2.
> >
> > I originally posted this early this year, and it prompted a debate
> > about what the "proper" way that Linux should do microcode updates,
> > with the general concensus being "earlier", ideally in the bootloader
> > (or in the case of Xen, as the hypervisor boots before starting any
> > domains).  However, as far as I know there has been no progress along
> > those lines.

Err,

wait a sec, last time the suggestion was that _because_ xen supports the
multiboot protocol, implementing an early solution would be even easier
for you:

http://marc.info/?l=linux-kernel&m=129667641316947&w=2

Why would a xen microcode solution would even be contingent on how
upstream Linux solves it (and when)?

AFAICT, you want to hand off the microcode image from the bootloader to
the hypervisor and update ucode there - no need for dom0 changes...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
