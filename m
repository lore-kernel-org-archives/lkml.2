Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1LMUrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:47:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:28598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1LMUrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:47:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86193887"
Date: Tue, 13 Dec 2011 21:52:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/4] fixes for twl4030-irq in mainline
Message-ID: <20111213205256.GG2796@sortiz-mobl>
References: <20111126201334.16080.85045.stgit@notabene.brown>
 <20111212173819.GT13952@sortiz-mobl>
 <CAMP44s1D+HXP_prHVwEztLCd1XJpnzukFeNKH_xEZrq06jEouA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s1D+HXP_prHVwEztLCd1XJpnzukFeNKH_xEZrq06jEouA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Tue, Dec 13, 2011 at 04:12:02PM +0200, Felipe Contreras wrote:
> Hi,
> 
> On Mon, Dec 12, 2011 at 7:38 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > On Sun, Nov 27, 2011 at 07:17:41AM +1100, NeilBrown wrote:
> >>   The recent tidying up of twl4030-irq seems to have left it broken.
> >> At least it doesn't work for me on my gta04 (www.gta04.org).  The
> >> first interrupt from the device freezes the whole system (by being
> >> constantly delivered)
> >>
> >> The following 4 patches make it work for me and addresses some other
> >> less critical issues like a typo in a comment :-)
> >
> > Thanks, I applied all 4 of them.
> 
> Did you apply them for 3.2 or 3.3? Without the first patch any system
> that has a twl4030 chip will immediately hang on the first interrupt,
> and many functions of twl4030 will just not work without the second
> one.
Thanks for the heads up. I applied the first 2 patches to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
