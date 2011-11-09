Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1KIQwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:52:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:52393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1KIQwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:52:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="72905950"
Subject: Re: Staging clear up
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111109164211.GA4016@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
	 <20111109121329.GC21630@sirena.org.uk>
	 <1320854413.32205.948.camel@vkoul-udesk3>
	 <20111109164211.GA4016@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 22:17:41 +0530
Message-ID: <1320857261.32205.1051.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 16:42 +0000, Mark Brown wrote:
> On Wed, Nov 09, 2011 at 09:30:13PM +0530, Vinod Koul wrote:
> 
> > Alan, if you folks are not using the staging driver I am okay for its
> > removal
> 
> Someone will need to fix the build breakage from peering at the headers
> from staging.
Not really. The current driver will not build unless you tweak the
Kconfig. It has clear depends rule, so build will not break.

-- 
~Vinod

