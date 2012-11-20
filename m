Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab2KTV6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:58:44 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43444 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2KTV6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:58:42 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv9 0/3] Runtime Interpreted Power Sequences
To: Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 20 Nov 2012 21:58:30 +0000
Message-Id: <20121120215830.3A4C13E1821@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012 19:55:44 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Apologies for sending two patchsets in two days - the main purpose
> of this new revision is to add the linux-arm-kernel list to the
> audience. A few suggestions from v8 have also been added.

Just to be clear from my previous reply, don't merge this series. The DT
binding is not good.

g.
