Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab2INQFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:05:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35411 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2INQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:05:15 -0400
Date: Fri, 14 Sep 2012 17:05:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 4/7] mfd: ab8500-core: Apply the AB8500 CODEC's
 compatible string to its MFD cell
Message-ID: <20120914160506.GE12893@gmail.com>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
 <1343392734-11805-5-git-send-email-lee.jones@linaro.org>
 <20120727133633.GQ16859@sortiz-mobl>
 <20120729202806.GC4384@opensource.wolfsonmicro.com>
 <20120730132422.GW16859@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120730132422.GW16859@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:24:22PM +0200, Samuel Ortiz wrote:
> On Sun, Jul 29, 2012 at 09:28:07PM +0100, Mark Brown wrote:
> > On Fri, Jul 27, 2012 at 03:36:33PM +0200, Samuel Ortiz wrote:
> > > On Fri, Jul 27, 2012 at 01:38:51PM +0100, Lee Jones wrote:
> > 
> > > > Provide a compatible string for the AB8500 CODEC to aid in
> > > > configuration property look-up from its associated Device Tree
> > > > node.
> > 
> > > Applied as well.
> > 
> > I remain *deeply* unconvinced that this is tasteful design for the
> > device tree bindings, and it's certainly not needed urgently for v3.6 as
> > there's no DT bindings on the CODEC side.
> Fair enough, I'll keep this one for the next merge window.

Chasing this, as it still doesn't appear in v3.7 -next.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
