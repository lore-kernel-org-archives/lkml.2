Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1CYAOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:14:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55334 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1CYAOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:14:33 -0400
Date: Fri, 25 Mar 2011 00:14:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Cyril Chemparathy <cyril@ti.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] regulator: fix tps6524x section mismatch
Message-ID: <20110325001430.GB26856@sirena.org.uk>
References: <20110324133059.eb17c442.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324133059.eb17c442.randy.dunlap@oracle.com>
X-Cookie: Live free or die.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:30:59PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch that is caused by init code calling exit code:
> pmic_remove() cannot be marked as __devexit.
> 
> WARNING: drivers/regulator/tps6524x-regulator.o(.devinit.text+0x205): Section mismatch in reference from the function pmic_probe() to the function .devexit.text:pmic_remove()

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
