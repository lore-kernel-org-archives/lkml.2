Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663Ab0GQBXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:23:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44406 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486Ab0GQBXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:23:09 -0400
X-Sasl-enc: lplNGnuVKNaCkSjrl5/xYDXY2e6t1CsuDN0yyW4VFdzA 1279329788
Date: Fri, 16 Jul 2010 22:23:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
 Lenovo T400/T500
Message-ID: <20100717012304.GA27741@khazad-dum.debian.net>
References: <4C3DCAA4.9050602@gmail.com>
 <20100714143625.GA30721@srcf.ucam.org>
 <20100715223149.GC27512@khazad-dum.debian.net>
 <20100715225022.GA31377@srcf.ucam.org>
 <20100715230023.GE27512@khazad-dum.debian.net>
 <20100715230825.GA31651@srcf.ucam.org>
 <20100716030107.GH27512@khazad-dum.debian.net>
 <20100716200824.GA7142@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716200824.GA7142@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Matthew Garrett wrote:
> 1) The ACPI reboot vector reboots these machines instantly, but the flag 
> that indicates we should use it isn't set.
> 2) Windows takes 9 seconds to reboot on the same hardware.
> 
> It just sounds like broken firmware.

I'm confused.  Is it the PCI reboot vector, or the ACPI reboot vector
that acts instantly?  The bug reporters say that they use reboot=pci to
have instant reboot, in this thread...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
