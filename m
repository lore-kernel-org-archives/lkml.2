Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2GRAxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:53:25 -0400
Received: from linux-sh.org ([111.68.239.195]:42963 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2GRAxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:53:20 -0400
Date: Wed, 18 Jul 2012 09:52:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: Boot breaks in -next from LEGACY to LINEAR conversion
Message-ID: <20120718005230.GA15680@linux-sh.org>
References: <20120717185749.GJ4477@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717185749.GJ4477@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 07:57:49PM +0100, Mark Brown wrote:
> -next fails to boot for me today on my s3c64xx based systems.  Walking
> back to the last time I tried and bisecting likely branches I find that
> commit 910139 (irqdomain: Replace LEGACY mapping with LINEAR) is the one
> that introduces the build break.  Unfortunately the boot fails before I
> get a console which makes diagnosis somewhat more tricky than would be
> ideal.  Any ideas?

Does http://www.spinics.net/lists/linux-sh/msg11995.html fix it for you?

I did Cc you on the legacy -> linear thread, but perhaps you missed it.
