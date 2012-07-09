Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2GINGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:06:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59544 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2GINGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:06:33 -0400
Date: Mon, 9 Jul 2012 14:06:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709130629.GA29130@srcf.ucam.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120707032907.GA15120@srcf.ucam.org>
 <20120709123253.GA31383@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709123253.GA31383@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 01:32:56PM +0100, Mark Brown wrote:

> If you end up having to write two whole drivers that sounds enormously
> depressing especially for those of us working on devices that aren't
> architecture specific.  We've managed to avoid that thus far with device
> tree and platform data, would it not be possible to mandate that people
> use ACPI in a vaugley sane way which can support this too?

There's ongoing discussion about unifying ACPI and ftd representation, 
and once that's done this isn't a problem, but right now there's no 
terribly straightforward way to do this without a lot of basically 
boilerplate code. The biggest issue is that ACPI has a very different 
idea about event delivery and we'd need some way to abstract that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
