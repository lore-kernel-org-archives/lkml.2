Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0HPOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:49:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52803 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab0HPOtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:49:20 -0400
Date: Mon, 16 Aug 2010 15:49:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Notes from the Boston Linux Power Management
	Mini-summit - August 9th, 2010
Message-ID: <20100816144914.GB10354@sirena.org.uk>
References: <alpine.LFD.2.00.1008150134180.7641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1008150134180.7641@localhost.localdomain>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 01:36:33AM -0400, Len Brown wrote:

> A gap:
> 
> On OMAP, bus control is independent of CPU frequency control,
> so cpufreq and cpuidle don't quite fit the bill.
> 
> Perhaps a "bus-idle" analogous to "cpu-idle" may be appropriate?

FWIW this applies to a bunch of other embedded processors too - OMAP
isn't particularly unique here, though it's one of the furthest along in
terms of exploting this in mainline Linux.
