Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2CaVpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:45:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59150 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2CaVpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:45:08 -0400
Date: Sat, 31 Mar 2012 22:45:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Ethernet driver for the WIZnet W5300 chip
Message-ID: <20120331214506.GC19965@sirena.org.uk>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru>
 <1333090806-27988-1-git-send-email-msink@permonline.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333090806-27988-1-git-send-email-msink@permonline.ru>
X-Cookie: No alcohol, dogs or horses.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 01:00:05PM +0600, Mike Sinkovsky wrote:
> Based on original driver from chip manufacturer, but nearly full rewite.
> 
> Tested and used in production with Blackfin BF531 embedded processor.

My comments on the other WIZnet driver look like they apply to this one
too.
