Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab2BCVkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:40:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab2BCVkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:40:12 -0500
Date: Fri, 3 Feb 2012 22:40:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>
Subject: Re: [PATCH] Don't needlessly include linux/version.h in
 drivers/mfd/ab5500-core.c
In-Reply-To: <CACRpkdbp=Z0VWwpEv_4KcDaRpAq8O09v=+yf=gtQ+J87i7P-bg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1202032240050.25026@pobox.suse.cz>
References: <alpine.LNX.2.00.1201152124260.13389@swampdragon.chaosbits.net> <CACRpkdbp=Z0VWwpEv_4KcDaRpAq8O09v=+yf=gtQ+J87i7P-bg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Linus Walleij wrote:

> On Sun, Jan 15, 2012 at 9:26 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > As 'make versioncheck' so nicely points out, there's no need for
> > drivers/mfd/ab5500-core.c to #include the linux/version.h header.
> > This patch removes the pointless include.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Remnant of some kernelversion-specific code that is now
> deleted. Thanks Jesper!
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
