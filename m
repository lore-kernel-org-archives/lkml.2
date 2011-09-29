Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1I2LAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:00:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58873 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555Ab1I2LAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:00:14 -0400
Date: Thu, 29 Sep 2011 12:00:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110929110011.GL3697@opensource.wolfsonmicro.com>
References: <20110922184614.25419.84606.stgit@ponder>
 <20110926152634.GN2946@opensource.wolfsonmicro.com>
 <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com>
 <201109271550.36427.arnd@arndb.de>
 <20110927210849.GD3994@ponder.secretlab.ca>
 <20110927221308.GA2674@opensource.wolfsonmicro.com>
 <20110928231410.GF2838@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928231410.GF2838@ponder.secretlab.ca>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 06:14:10PM -0500, Grant Likely wrote:

> For your question, I still think it is the driver that gets to make
> the decision.  If it can proceed without a resource, then it should go
> ahead and succeed on the probe, and then arrange to either be notified
> of new gpio controller (or whatever) registrations, or poll for the
> resource to be set up.

Right, I do tend to agree.  This is something we'll have to bear in mind
when deploying this stuff - drivers that are doing this sort of stuff
are going to get surprised.
