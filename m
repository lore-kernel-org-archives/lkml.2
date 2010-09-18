Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0IRKIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 06:08:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58508 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753364Ab0IRKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 06:08:29 -0400
Date: Sat, 18 Sep 2010 11:08:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Nishanth Menon <nm@ti.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Madhusudhan Chikkature Rajashekar <madhu.cr@ti.com>,
        Sergio Alberto Aguirre Rodriguez <saaguirre@ti.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        "Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
        linux-omap <linux-omap@vger.kernel.org>, Thara Gopinath <thara@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Roberto Granados Dorado <x0095451@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Romit Dasgupta <ro.mit@ti.com>,
        "Kristo Tero (Nokia-MS/Tampere)" <Tero.Kristo@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjeev Premi <premi@ti.com>
Subject: Re: [linux-pm] [PATCH] opp: introduce library for device-specific
	OPPs
Message-ID: <20100918100827.GC22248@opensource.wolfsonmicro.com>
References: <1284686973-13993-1-git-send-email-nm@ti.com> <20100917153643.GC29739@sirena.org.uk> <20100917164543.GI20325@esdhcp04044.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917164543.GI20325@esdhcp04044.research.nokia.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 07:45:43PM +0300, Phil Carmody wrote:
> On 17/09/10 17:36 +0200, ext Mark Brown wrote:

> > It might be clearer to use some term other than enabled in the code -
> > when reading I wasn't immediately sure if enabled meant that it was
> > available to be selected or if it was the active operating point.  How
>   ^^^^^^^^^
> > about 'allowed' (though I'm not 100% happy with that)?

> I think your query contains its own answer.

Yeah, I didn't pick that because all of them are available in the sense
that they could in the future be enabled but I do think it's the best
option.
