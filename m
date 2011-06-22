Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab1FVS3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:29:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60476 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1FVS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:29:23 -0400
Date: Wed, 22 Jun 2011 19:29:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Margarita Olaya <magi@slimlogic.co.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mfd: tps65912 needs MFD_CORE
Message-ID: <20110622182915.GA13847@sirena.org.uk>
References: <20110622163651.7ebc407c.sfr@canb.auug.org.au> <20110622100615.c79765ff.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622100615.c79765ff.randy.dunlap@oracle.com>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:06:15AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> MFD_TPS65912 should select MFD_CORE so that mfd interfaces are
> available to it.  This fixes a build error when MFD_CORE=m and
> MFD_TPS65912=y (and no other TPS65912 kconfig symbols are enabled,
> so no other select MFD_CORE was done).

I posted a better patch for this earlier today - the bigger problem here
is that as with other MFD cores MFD_TPS65912 shouldn't be directly
selectable at all as it can't do anything useful without a bus
interface.
