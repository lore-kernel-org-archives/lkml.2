Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1JPLCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 07:02:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35848 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1JPLCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 07:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	<1318570705-17595-3-git-send-email-vinod.koul@intel.com>
Date: Sun, 16 Oct 2011 13:02:03 +0200
X-Google-Sender-Auth: Gzr4ZmUld1AS-wF8K0bU6WSNZkA
Message-ID: <CAKnu2MouaqhoNzf_6f2=9fk6hYVaXnSxz43x=SRCpGhu8WAUcQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Vinod Koul <vinod.koul@intel.com>:

Looks like the right thing to do following the recent sematic discussions,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
