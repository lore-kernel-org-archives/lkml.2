Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab2EXGTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:19:22 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:11054
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab2EXGTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:19:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 24 May 2012 14:39:00 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, <marc@cpdesign.com.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524063859.GD7843@S2100-06.ap.freescale.net>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
 <20120523164203.GA7843@S2100-06.ap.freescale.net>
 <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
 <20120524004851.GB7843@S2100-06.ap.freescale.net>
 <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:07:43AM -0300, Fabio Estevam wrote:
> I am trying to understand why mx31pdk still fails.
> 
So different from imx51-babbage which uses MC13892, mx31pdk uses
MC13783?  But both chips should have the same regmap, right?

-- 
Regards,
Shawn

