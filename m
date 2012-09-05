Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2IEXok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:44:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42946 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165Ab2IEXoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:44:39 -0400
Date: Thu, 6 Sep 2012 07:44:33 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linus.walleij@linaro.org, shiraz.linux.kernel@gmail.com,
        aletes.xgr@gmail.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Subject: Re: [PATCH] spi/pl022: Fix chipselects pointer computation
Message-ID: <20120905234432.GI10580@opensource.wolfsonmicro.com>
References: <1346660069-16049-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346660069-16049-1-git-send-email-stigge@antcom.de>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 10:14:29AM +0200, Roland Stigge wrote:
> The new chip select handling via GPIO introduced a pointer computation bug:

Applied, thanks.
