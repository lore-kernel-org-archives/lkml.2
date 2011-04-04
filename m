Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1DDWhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:37:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54961 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755795Ab1DDWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:37:40 -0400
Date: Tue, 5 Apr 2011 07:37:45 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: linux-next: Tree for April 4 (sound/soc)
Message-ID: <20110404223744.GA4609@opensource.wolfsonmicro.com>
References: <20110404143546.e2bb3379.sfr@canb.auug.org.au>
 <20110404083747.34ed1398.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404083747.34ed1398.randy.dunlap@oracle.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 08:37:47AM -0700, Randy Dunlap wrote:
> On Mon, 4 Apr 2011 14:35:46 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110401:
> 
> 
> When CONFIG_SPI=n, CONFIG_I2C=n:

A patch was sent for this the other day, just waiting for review.
