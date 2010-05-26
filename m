Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0EZNzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:55:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0EZNzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:55:48 -0400
Date: Wed, 26 May 2010 09:55:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jon Hunter <jon-hunter@ti.com>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] transitional config CONFIG_GENERIC_CLOCKEVENTS
Message-ID: <20100526135537.GA31601@infradead.org>
References: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:44:15PM +0200, Christoph Egger wrote:
> @@ -25,5 +25,5 @@ config HIGH_RES_TIMERS
>  config GENERIC_CLOCKEVENTS_BUILD
>  	bool
>  	default y
> -	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
> +	depends on GENERIC_CLOCKEVENTS

At this point you can also get rid of GENERIC_CLOCKEVENTS_BUILD and
replace all instances of it with GENERIC_CLOCKEVENTS.

