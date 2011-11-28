Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1K1BD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:03:27 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:36879 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab1K1BD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:03:27 -0500
Subject: Re: [PATCH v2] i2c: convert drivers/i2c/* to use
 module_platform_driver()
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
In-Reply-To: <1322439206.2709.2.camel@phoenix>
References: <1322439206.2709.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 28 Nov 2011 09:02:30 +0800
Message-ID: <1322442150.8661.3.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 08:13 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/i2c/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Jochen Friedrich <jochen@scram.de>
> Cc: Peter Korsgaard <jacmet@sunsite.dk>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> Acked-by: Jochen Friedrich<jochen@scram.de>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
For i2c-puv3.c,
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks Axel,
Guan Xuetao

