Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1FGEwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:52:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:35032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1FGEwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:52:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,330,1304319600"; 
   d="scan'208";a="12798514"
From: "Du, Alek" <alek.du@intel.com>
To: "Tang, Feng" <feng.tang@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "jean-hugues.deschenes@octasic.com" 
	<jean-hugues.deschenes@octasic.com>
Date: Tue, 7 Jun 2011 12:52:36 +0800
Subject: RE: [PATCH v2] spi: reorganize drivers
Thread-Topic: [PATCH v2] spi: reorganize drivers
Thread-Index: AcwkzYHEnGvuxub8QF6co6WZopC1QAAAHa9g
Message-ID: <1865303E0DED764181A9D882DEF65FB697F73BFC1C@shsmsx502.ccr.corp.intel.com>
References: <20110606071829.10334.90865.stgit@ponder>
	<BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
	<BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com>
	<4DED0510.1030600@gmail.com>	<20110607102829.01392e7e@feng-i7>
	<BANLkTim927Ld28JmVfALscThef02XQJDWw@mail.gmail.com>
 <20110607124854.0e96813c@feng-i7>
In-Reply-To: <20110607124854.0e96813c@feng-i7>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

After the latest patches that Feng Tang sent out for SPI were merged, I don't see any good reason to do big change. It just works perfectly.

Thanks,
Alek
-----Original Message-----
From: Tang, Feng 
Sent: Tuesday, June 07, 2011 12:49 PM
To: Grant Likely
Cc: Dirk Brandewie; spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org; Mike Frysinger; Du, Alek; alan@linux.intel.com; jean-hugues.deschenes@octasic.com
Subject: Re: [PATCH v2] spi: reorganize drivers

Hi Grant,

On Tue, 7 Jun 2011 12:09:52 +0800
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Mon, Jun 6, 2011 at 8:28 PM, Feng Tang <feng.tang@intel.com> wrote:
> > On Tue, 7 Jun 2011 00:49:20 +0800
> > Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> >
> >> On 06/06/2011 09:38 AM, Grant Likely wrote:
> >> > On Mon, Jun 6, 2011 at 10:31 AM, Mike
> >> > Frysinger<vapier.adi@gmail.com>  wrote:
> >> >> On Mon, Jun 6, 2011 at 03:18, Grant Likely wrote:
> >> >>> Sort the SPI makefile and enforce the naming convention spi_*.c
> >> >>> for spi drivers.
> >> >>
> >> >> spi_topcliff_pch.c uses KBUILD_MODNAME with a few funcs, but
> >> >> perhaps those are only for /proc/ status tracking ?  worth
> >> >> double checking ...
> >> >
> >> > I just talked with Dirk Brandewie, who has a major rewrite to the
> >> > topcliff spi driver.  I'll let him comment on whether or not
> >> > changing KBUILD_MODNAME will cause any problems.
> >> >
> >>
> >> My changes are to the designware driver :-) I will get my patches
> >> re-based onto the spi-next branch and see if there any issues.
> >
> > If there is major rewrite to the dw_spi driver, please submit to
> > this list, as it is used by many devices out there and needs a
> > broad review
> 
> Hmmm.  Dirk, that could change things a bit.  From our conversation
> today my understanding was that there weren't few if any users outside
> of your circle.  If that isn't the case, then I'm going to be more
> cautious about merging the rewrite.  Who are the people I should make
> sure there is feedback from when the patch gets posted?

I don't know all the devices and users, but here is what I know: I've tested
Max3110 spi-uart (in-tree), Option GTM501L high-speed 3G modem (out of tree),
ektf1236 spi touch screen (out of tree). Alek Du (Cced) should have tested
current dw_spi driver with some spi bluetooth device and modem device. Also
the original author fordw_spi_mmio.c Jean-Hugues Deschense should have some
experience too.

Thanks,
Feng

> 
> g.
