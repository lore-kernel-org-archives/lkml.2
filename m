Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1I0WNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:13:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48945 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346Ab1I0WNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:13:12 -0400
Date: Tue, 27 Sep 2011 23:13:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110927221308.GA2674@opensource.wolfsonmicro.com>
References: <20110922184614.25419.84606.stgit@ponder> <20110926152634.GN2946@opensource.wolfsonmicro.com> <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com> <201109271550.36427.arnd@arndb.de> <20110927210849.GD3994@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927210849.GD3994@ponder.secretlab.ca>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 03:08:49PM -0600, Grant Likely wrote:

> Okay, will do.  How does EPROBE_DEFER 518 sound?

Note that I'm not sure this answers the issue I was raising - the issue
isn't that the caller doesn't know what the error code means, the issue
is that in some cases the driver needs to take a decision about what
failure to get a resource means.  Does it mean that the driver can work
fine and be slightly less featureful or should it cause a deferral?
