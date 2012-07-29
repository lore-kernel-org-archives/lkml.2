Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2G2U2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:28:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40080 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab2G2U2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:28:09 -0400
Date: Sun, 29 Jul 2012 21:28:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 4/7] mfd: ab8500-core: Apply the AB8500 CODEC's
 compatible string to its MFD cell
Message-ID: <20120729202806.GC4384@opensource.wolfsonmicro.com>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
 <1343392734-11805-5-git-send-email-lee.jones@linaro.org>
 <20120727133633.GQ16859@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727133633.GQ16859@sortiz-mobl>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 03:36:33PM +0200, Samuel Ortiz wrote:
> On Fri, Jul 27, 2012 at 01:38:51PM +0100, Lee Jones wrote:

> > Provide a compatible string for the AB8500 CODEC to aid in
> > configuration property look-up from its associated Device Tree
> > node.

> Applied as well.

I remain *deeply* unconvinced that this is tasteful design for the
device tree bindings, and it's certainly not needed urgently for v3.6 as
there's no DT bindings on the CODEC side.
