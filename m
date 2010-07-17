Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688Ab0GQB1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:27:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37988 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759603Ab0GQB1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:27:49 -0400
Date: Sat, 17 Jul 2010 02:27:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
	Lenovo T400/T500
Message-ID: <20100717012742.GA11262@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com> <20100714143625.GA30721@srcf.ucam.org> <20100715223149.GC27512@khazad-dum.debian.net> <20100715225022.GA31377@srcf.ucam.org> <20100715230023.GE27512@khazad-dum.debian.net> <20100715230825.GA31651@srcf.ucam.org> <20100716030107.GH27512@khazad-dum.debian.net> <20100716200824.GA7142@srcf.ucam.org> <20100717012304.GA27741@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100717012304.GA27741@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:23:04PM -0300, Henrique de Moraes Holschuh wrote:

> I'm confused.  Is it the PCI reboot vector, or the ACPI reboot vector
> that acts instantly?  The bug reporters say that they use reboot=pci to
> have instant reboot, in this thread...

The PCI one, since it's a function of the chipset. The ACPI one would 
act instantly (it's the PCI one, in this case) but it's marked as 
unsupported. However, the PCI one is poorly standardised - Windows never 
uses it, different chips have subtly different requirements and so on.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
