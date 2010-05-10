Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0EJJtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:49:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38622 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753072Ab0EJJs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:48:57 -0400
Date: Mon, 10 May 2010 10:48:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] pda_power: add support for writeable properties
Message-ID: <20100510094854.GB31804@rakim.wolfsonmicro.main>
References: <1273254733-7010-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273254733-7010-1-git-send-email-daniel@caiaq.de>
X-Cookie: There's no time like the pleasant.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 07:52:11PM +0200, Daniel Mack wrote:

> +	/* TODO: support other types than int */
> +	ret = strict_strtol(buf, 10, &long_val);
> +	if (ret < 0)
> +		return ret;

It'd be nicer if we could error out if this is used on properties with
an inappropriate type but we don't seem to have type information
anywhere convenient for implementing that, which is a bit unfortunate.

Otherwise this looks reasonable in itself.
