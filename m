Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2GGD3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 23:29:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49111 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2GGD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 23:29:13 -0400
Date: Sat, 7 Jul 2012 04:29:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120707032907.GA15120@srcf.ucam.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:05:41PM +0100, Catalin Marinas wrote:

> There is no hardware platform available at this point. From a kernel
> perspective, the aim is to minimise (or even completely remove) the
> platform code from the architecture specific directory. FDT is currently
> mandated and there are ongoing discussions for ACPI support.

While mandating FDT is a massive advance over arm32, if there's a chance 
that ACPI-based AArch64 platforms will ship in a similar timeframe to 
FDT then I think we should ensure that ACPI and FDT are merged 
beforehand - the alternative is that people are going to end up writing 
the same hardware driver twice for different firmware implementations. I 
don't think anyone benefits from introducing a platform that has 
multiple device representations[1]

[1] Yeah x86 has the same problem with PNP and ACPI and PCI and given 
how much pain that's caused me I wish someone had complained at the time

-- 
Matthew Garrett | mjg59@srcf.ucam.org
