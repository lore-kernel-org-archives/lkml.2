Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2IGIPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:15:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60918 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab2IGIPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:15:17 -0400
Date: Fri, 7 Sep 2012 16:15:03 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
Message-ID: <20120907081501.GA17749@opensource.wolfsonmicro.com>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
 <1346412846-17102-2-git-send-email-acourbot@nvidia.com>
 <201209061614.54022.heiko@sntech.de>
 <1887927.1deN8M9siP@percival>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1887927.1deN8M9siP@percival>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:04:24PM +0900, Alex Courbot wrote:

> If e.g. the power on sequence fails at step N (of M steps for that sequence), 
> one could try playing the corresponding power off sequence (either completely 
> of from step M - N), but then again we cannot rely on sequences to be 
> perfectly symetrical. Maybe this is more something for the calling driver to 
> check for and control?

That had been my thought too - depending on what the sequence is for it
may be that the corrective action is something very different to
reversing the sequence, for example a device reset may be required.
