Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1K0IsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 03:48:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33043 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1K0IsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 03:48:01 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jochen Friedrich <jochen@scram.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert drivers/i2c/* to use module_platform_driver()
References: <1322374332.2226.1.camel@phoenix>
Date: Sun, 27 Nov 2011 09:47:55 +0100
In-Reply-To: <1322374332.2226.1.camel@phoenix> (Axel Lin's message of "Sun, 27
	Nov 2011 14:12:12 +0800")
Message-ID: <87aa7ihryc.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Axel" == Axel Lin <axel.lin@gmail.com> writes:

 Axel> This patch converts the drivers in drivers/i2c/* to use the
 Axel> module_platform_driver() macro which makes the code smaller and a bit
 Axel> simpler.

 Axel> Cc: Jean Delvare <khali@linux-fr.org>
 Axel> Cc: Ben Dooks <ben-linux@fluff.org>
 Axel> Cc: Jochen Friedrich <jochen@scram.de>
 Axel> Cc: Peter Korsgaard <jacmet@sunsite.dk>
 Axel> Cc: Wolfram Sang <w.sang@pengutronix.de>
 Axel> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
 Axel> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
 Axel> Cc: Barry Song <21cnbao@gmail.com>
 Axel> Cc: Linus Walleij <linus.walleij@linaro.org>
 Axel> Cc: Yong Zhang <yong.zhang0@gmail.com>
 Axel> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
 Axel> Cc: Grant Likely <grant.likely@secretlab.ca>
 Axel> Cc: Samuel Ortiz <sameo@linux.intel.com>
 Axel> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good for i2c-ocores / gpio-i2cmux:

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
