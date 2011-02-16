Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab1BPHtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:49:47 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:39707 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757460Ab1BPHtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:49:42 -0500
Date: Wed, 16 Feb 2011 08:25:14 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Pavel Machek <pma@sysgo.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>, cko@sysgo.com,
        eric.miao@marvell.com, Andrew Morton <akpm@osdl.org>
Subject: Re: pcmcia vs. MECR on pxa25x/sa1111
Message-ID: <20110216072514.GB27029@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Pavel Machek <pma@sysgo.com>, Russell King <rmk@arm.linux.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>, cko@sysgo.com,
	eric.miao@marvell.com, Andrew Morton <akpm@osdl.org>
References: <20110201120303.GA30464@pma.sysgo.com>
 <20110201125921.GA7984@flint.arm.linux.org.uk>
 <20110204080343.GA31740@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204080343.GA31740@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Fri, Feb 04, 2011 at 09:03:43AM +0100, Pavel Machek wrote:
> 
> After 2.6.34 changes, __pxa2xx_drv_pcmcia_probe() was replaced by
> sa1111_pcmcia_add(). That unfortunately means that configure_sockets()
> is not called, leading to MECR not being set properly, leading to
> strange crashes.
> 
> Tested on pxa255+sa1111, I do not have lubbock board nearby. Perhaps
> cleaner solution exists?
> 
> Signed-off-by: Pavel Machek <pma@sysgo.com>
> 
> ---
> 
> Here's updated version. I'd prefer not to do too extensive changes as
> I do not have lubbock nearby.

will you pick this up, or shall I?

Best,
	Dominik

