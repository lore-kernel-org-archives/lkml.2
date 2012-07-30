Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2G3NY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:24:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:5491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab2G3NY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="173148475"
Date: Mon, 30 Jul 2012 15:24:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 4/7] mfd: ab8500-core: Apply the AB8500 CODEC's
 compatible string to its MFD cell
Message-ID: <20120730132422.GW16859@sortiz-mobl>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
 <1343392734-11805-5-git-send-email-lee.jones@linaro.org>
 <20120727133633.GQ16859@sortiz-mobl>
 <20120729202806.GC4384@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729202806.GC4384@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 09:28:07PM +0100, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 03:36:33PM +0200, Samuel Ortiz wrote:
> > On Fri, Jul 27, 2012 at 01:38:51PM +0100, Lee Jones wrote:
> 
> > > Provide a compatible string for the AB8500 CODEC to aid in
> > > configuration property look-up from its associated Device Tree
> > > node.
> 
> > Applied as well.
> 
> I remain *deeply* unconvinced that this is tasteful design for the
> device tree bindings, and it's certainly not needed urgently for v3.6 as
> there's no DT bindings on the CODEC side.
Fair enough, I'll keep this one for the next merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
