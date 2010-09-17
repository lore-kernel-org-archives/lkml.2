Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0IQQtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:49:18 -0400
Received: from smtp.nokia.com ([147.243.1.47]:62983 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0IQQtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:49:15 -0400
Date: Fri, 17 Sep 2010 19:45:43 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
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
Message-ID: <20100917164543.GI20325@esdhcp04044.research.nokia.com>
References: <1284686973-13993-1-git-send-email-nm@ti.com> <20100917153643.GC29739@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917153643.GC29739@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/10 17:36 +0200, ext Mark Brown wrote:
> On Thu, Sep 16, 2010 at 08:29:33PM -0500, Nishanth Menon wrote:
> 
> > +struct opp_def {
> > +	unsigned long freq;
> > +	unsigned long u_volt;
> > +
> > +	bool enabled;
> > +};
> 
> It might be clearer to use some term other than enabled in the code -
> when reading I wasn't immediately sure if enabled meant that it was
> available to be selected or if it was the active operating point.  How
  ^^^^^^^^^
> about 'allowed' (though I'm not 100% happy with that)?

I think your query contains its own answer.

Phil
