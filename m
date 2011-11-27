Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1K0Tui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:50:38 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:26158 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1K0Tug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:50:36 -0500
Date: Sun, 27 Nov 2011 20:50:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert drivers/i2c/* to use 
 module_platform_driver()
Message-ID: <20111127205028.708ea59f@endymion.delvare>
In-Reply-To: <20111127194648.GA26533@pengutronix.de>
References: <1322374332.2226.1.camel@phoenix>
	<20111127202212.44ebf4c4@endymion.delvare>
	<20111127194648.GA26533@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Nov 2011 20:46:48 +0100, Wolfram Sang wrote:
> 
> > > -module_init(gpiomux_init);
> > > -module_exit(gpiomux_exit);
> > > +module_platform_driver(gpiomux_driver);
> > 
> > This one would be better as a separate patch, as it touches a different
> > subdirectory, which I am responsible for.
> 
> ... which has a patch pending[1], hint ;)
> 
> [1] http://comments.gmane.org/gmane.linux.drivers.i2c/9432

Yes, that's one of the reasons why I think a separate patch would be
more appropriate. It might be difficult to avoid patch collisions
otherwise.

-- 
Jean Delvare
