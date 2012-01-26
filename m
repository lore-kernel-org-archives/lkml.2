Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab2AZLv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:51:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57328 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2AZLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:51:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120125002340.GV22818@atomide.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
	<20120120161727.21955.7437.stgit@kaulin.local>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB383@HQMAIL01.nvidia.com>
	<20120120173915.GP22818@atomide.com>
	<20120125002340.GV22818@atomide.com>
Date: Thu, 26 Jan 2012 12:51:57 +0100
Message-ID: <CACRpkdb0AeEvNeTWq0Q87kqURSEaE6PgCnXFbeP4D3mLgDPZhA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is
 not set
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 1:23 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Tony Lindgren <tony@atomide.com> [120120 09:06]:

> Here's this one updated, looks like we can keep it readable
> even without match_found if we continue the search early based
> on !map->hog_on_boot.

Thanks, patch applied with Stephens ACK.

Yours,
Linus Walleij
