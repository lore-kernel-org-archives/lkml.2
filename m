Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298Ab0GSP6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:58:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37848 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934478Ab0GSP6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:58:21 -0400
Date: Mon, 19 Jul 2010 16:58:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
Message-ID: <20100719155811.GA18754@srcf.ucam.org>
References: <4C4325E0.5020407@fusionio.com> <20100718184243.GA4062@srcf.ucam.org> <4C4383D9.3060705@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4383D9.3060705@pobox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 06:44:41PM -0400, Jeff Garzik wrote:

> I would have quirked AHCI/piix hardware into AHCI mode long ago, if  
> firmwares defaulting to piix mode would actually program the PCI BAR  
> correctly.

If you perform the fixup early enough then the PCI resource allocation 
code should take a decent stab at it. I'd feel more comfortable with 
that once we start using ACPI _CRS by default, since that gives us a 
much better chance of avoiding conflicting with some bit of motherboard 
hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
