Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0GPUIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:08:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50636 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759163Ab0GPUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:08:37 -0400
Date: Fri, 16 Jul 2010 21:08:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
	Lenovo T400/T500
Message-ID: <20100716200824.GA7142@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com> <20100714143625.GA30721@srcf.ucam.org> <20100715223149.GC27512@khazad-dum.debian.net> <20100715225022.GA31377@srcf.ucam.org> <20100715230023.GE27512@khazad-dum.debian.net> <20100715230825.GA31651@srcf.ucam.org> <20100716030107.GH27512@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716030107.GH27512@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok.

1) The ACPI reboot vector reboots these machines instantly, but the flag 
that indicates we should use it isn't set.
2) Windows takes 9 seconds to reboot on the same hardware.

It just sounds like broken firmware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
