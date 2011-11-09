Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1KIQxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:53:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166Ab1KIQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:53:18 -0500
Date: Wed, 9 Nov 2011 16:53:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109165316.GB4016@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
 <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
 <20111109164211.GA4016@opensource.wolfsonmicro.com>
 <1320857261.32205.1051.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320857261.32205.1051.camel@vkoul-udesk3>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 10:17:41PM +0530, Vinod Koul wrote:
> On Wed, 2011-11-09 at 16:42 +0000, Mark Brown wrote:

> > Someone will need to fix the build breakage from peering at the headers
> > from staging.

> Not really. The current driver will not build unless you tweak the
> Kconfig. It has clear depends rule, so build will not break.

Well, if that's the case we may as well delete the ASoC driver too since
it'll not be possible to build it :)
