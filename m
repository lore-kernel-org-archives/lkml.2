Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2DPRfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:35:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:31187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab2DPRfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:35:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154240179"
Date: Mon, 16 Apr 2012 19:44:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Sort Kconfig entries for mfd drivers
Message-ID: <20120416174410.GT24130@sortiz-mobl>
References: <1334199051.8736.3.camel@phoenix>
 <CACRpkda2M1CWJymf2QBmpKzVo_+UGMEV+sj2aF-vjbHStwrtAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda2M1CWJymf2QBmpKzVo_+UGMEV+sj2aF-vjbHStwrtAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel, Linus,

On Fri, Apr 13, 2012 at 02:35:48PM +0200, Linus Walleij wrote:
> On Thu, Apr 12, 2012 at 4:50 AM, Axel Lin <axel.lin@gmail.com> wrote:
> 
> > Sort Kconfig entries by chip vendor name first, then driver name.
> > Having the Kconfig entries sorted makes it easier for users to find the
> > driver they want to enable.
> > This change also encourages new coming drivers to be put in proper location
> > rather than to be added at random location.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> > Hi Samuel,
> > I generate this patch against linux-next 20120411.
> > If you think this patch is ok, pls apply this one and
> > ignore my previous patch "mfd: Move MFD_TPS65090 and
> > TPS65911_COMPARATOR Kconfig entries to proper location".
> 
> This is going to cause a number of merge conflicts for upcoming
> patches from my side, I'd really like this to go into the -rc:s
> if accepted so I can rely on it being present as a merge base.
It's definitely too late for rc:s, so I'll postpone this one for after Linus
code gets merged.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
