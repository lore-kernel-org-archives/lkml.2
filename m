Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1I0VS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:18:57 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37186 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1I0VS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:18:56 -0400
Date: Tue, 27 Sep 2011 15:08:49 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110927210849.GD3994@ponder.secretlab.ca>
References: <20110922184614.25419.84606.stgit@ponder>
 <20110926152634.GN2946@opensource.wolfsonmicro.com>
 <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com>
 <201109271550.36427.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109271550.36427.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 03:50:36PM +0200, Arnd Bergmann wrote:
> On Monday 26 September 2011, Grant Likely wrote:
> > Actually, in the next iteration, I'm thinking it would be a good idea
> > to create a new #define to only be used by probe deferral.  I want it
> > to be easy to find all the drivers that are using this mechanism
> > without needing to filter all the unrelated hits.  However, this is a
> > kernel-only thing so it is probably not appropriate to add it to
> > include/asm-generic/errno.h.  I could use some guidance/advice as to
> > the best way to handle this.
> 
> include/linux/errno.h already has a bunch of kernel-internal error
> codes that are never supposed to be seen in user space. Just
> add one there, the next free one right now is 517, after
> ERESTART_RESTARTBLOCK.

Okay, will do.  How does EPROBE_DEFER 518 sound?

g.
