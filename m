Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab1IXLyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 07:54:43 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22680 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1IXLyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 07:54:40 -0400
Date: Sat, 24 Sep 2011 13:53:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de,
        Sonic Zhang <sonic.zhang@analog.com>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Barry Song <21cnbao@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Joe Perches <joe@perches.com>, Dave Airlie <airlied@linux.ie>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Magnus Damm <damm@opensource.se>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 32/55] i2c: irq: Remove IRQF_DISABLED
Message-ID: <20110924135335.2be8d1be@endymion.delvare>
In-Reply-To: <1316681962-8217-33-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
	<1316681962-8217-33-git-send-email-yong.zhang0@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011 16:58:59 +0800, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Barry Song <21cnbao@gmail.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c   |    4 ++--
>  drivers/i2c/busses/i2c-designware.c |    2 +-
>  drivers/i2c/busses/i2c-highlander.c |    2 +-
>  drivers/i2c/busses/i2c-nomadik.c    |    2 +-
>  drivers/i2c/busses/i2c-nuc900.c     |    2 +-
>  drivers/i2c/busses/i2c-pmcmsp.c     |    2 +-
>  drivers/i2c/busses/i2c-s3c2410.c    |    2 +-
>  drivers/i2c/busses/i2c-sh7760.c     |    2 +-
>  drivers/i2c/busses/i2c-sh_mobile.c  |    2 +-
>  drivers/i2c/busses/i2c-stu300.c     |    2 +-
>  10 files changed, 11 insertions(+), 11 deletions(-)

Ben, I'll let you pick this patch as it only touches drivers which are
under your responsibility. This will limit the risk of conflicts
between our trees.

-- 
Jean Delvare
