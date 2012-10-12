Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2JLFQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:16:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36985 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab2JLFQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:16:12 -0400
Date: Fri, 12 Oct 2012 14:16:00 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Christopher Heiny <Cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Message-ID: <20121012051558.GK11726@opensource.wolfsonmicro.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
 <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
 <20121009082719.GC8237@opensource.wolfsonmicro.com>
 <BFABBC009FBA1C43B207B15FD485ABD922C22BE7@USW-MAIL1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD922C22BE7@USW-MAIL1.synaptics-inc.local>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 03:56:22AM +0000, Christopher Heiny wrote:

Fix your mailer to word wrap within paragraphs.

> If this feature is a deal-breaker, we can take it out.  In the absence
> of a generic GPIO implementation for CS, though, I'd much rather leave
> it in.  Once generic GPIO CS arrives, we'll remove it pretty quickly.  

Why not just implement this at an appropriate level in the SPI
subsystem?  One of the great things about Linux is that you can change
the core code...
