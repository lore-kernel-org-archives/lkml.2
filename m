Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2GIMdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:33:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48510 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2GIMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:33:00 -0400
Date: Mon, 9 Jul 2012 13:32:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709123253.GA31383@sirena.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120707032907.GA15120@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120707032907.GA15120@srcf.ucam.org>
X-Cookie: Beware of dog.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 04:29:08AM +0100, Matthew Garrett wrote:

> While mandating FDT is a massive advance over arm32, if there's a chance 
> that ACPI-based AArch64 platforms will ship in a similar timeframe to 
> FDT then I think we should ensure that ACPI and FDT are merged 
> beforehand - the alternative is that people are going to end up writing 
> the same hardware driver twice for different firmware implementations. I 
> don't think anyone benefits from introducing a platform that has 
> multiple device representations[1]

If you end up having to write two whole drivers that sounds enormously
depressing especially for those of us working on devices that aren't
architecture specific.  We've managed to avoid that thus far with device
tree and platform data, would it not be possible to mandate that people
use ACPI in a vaugley sane way which can support this too?
