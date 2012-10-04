Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab2JDNvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:51:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:1135 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102Ab2JDNve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:51:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,535,1344236400"; 
   d="scan'208";a="229889554"
Date: Thu, 4 Oct 2012 15:51:30 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Marc Reilly <marc@cpdesign.com.au>, linux-arm-kernel@lists.infradead.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx driver
Message-ID: <20121004135130.GC5554@sortiz-mobl>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <11987916.rOoNGcb1ly@dev1>
 <CAOMZO5AVP1L-6A7cmV-kQEfG1C+vczFKT=sQbFtLJDaGau0kRg@mail.gmail.com>
 <CAOMZO5BqZpy5Cz0BxbpdOY=sjMjhSOjfQZmJ4j7Xwe6Q7x6Yig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BqZpy5Cz0BxbpdOY=sjMjhSOjfQZmJ4j7Xwe6Q7x6Yig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Thu, Oct 04, 2012 at 10:01:21AM -0300, Fabio Estevam wrote:
> Hi Samuel,
> 
> On Wed, Sep 5, 2012 at 11:22 AM, Fabio Estevam <festevam@gmail.com> wrote:
> > Hi Samuel,
> >
> > On Thu, Jul 12, 2012 at 8:02 PM, Marc Reilly <marc@cpdesign.com.au> wrote:
> >> Hi Uwe,
> >>
> >>> This series was tested on a Phytec pcm038 (mc13783 on spi) using
> >>> traditional boot (i.e. not dt) and on a i.MX53 based machine (mc34708 on
> >>> i2c) using dt boot.
> >>>
> >>> Philippe's patches are already in next, they are just included here for
> >>> those who want to test the patches. The 'mfd/mc13xxx: drop modifying
> >>> driver's id_table in probe' was already sent out yesterday and is
> >>> included here because the last patch depends on it.
> >>>
> >>
> >> For all patches (that don't already have it):
> >> Acked-by: Marc Reilly <marc@cpdesign.com.au>
> >
> > Can this series be applied?
> 
> Any comments on this series, please?
Did you send it to my samuel.ortiz@intel.com email ? I never look at it when
going through my MFD backlog, which is why it was not applied. Which is why it
won't be part of the 3.7 merge window, sorry about that.

 
> I want to add mc34708 support to mx53qsb and need this series to be applied.
I understand. I'll queue it to my for-next branch as soon as the merge window
is closed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

