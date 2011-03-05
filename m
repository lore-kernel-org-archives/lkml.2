Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1CEL3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 06:29:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57460 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752642Ab1CEL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 06:29:15 -0500
Date: Sat, 5 Mar 2011 11:29:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH -next] soc: sgtl5000 uses regulator interfaces
Message-ID: <20110305112936.GA30187@opensource.wolfsonmicro.com>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
 <20110304173357.23d36116.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304173357.23d36116.randy.dunlap@oracle.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 05:33:57PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> sgtl5000 uses regulator interfaces, so make selecting it depend
> on REGULATOR.
> 
> sgtl5000.c:(.text+0x4ae33): undefined reference to `regulator_unregister'
> sgtl5000.c:(.text+0x4af41): undefined reference to `rdev_get_drvdata'
> sgtl5000.c:(.text+0x4b191): undefined reference to `regulator_register'

Since the regulator on the device is optional this isn't the best fix,
the code should be updated to support building without regulator.  
