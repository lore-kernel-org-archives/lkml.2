Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab1JDVBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 17:01:31 -0400
Received: from trinity.fluff.org ([89.16.178.74]:59040 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933618Ab1JDVB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 17:01:29 -0400
Date: Tue, 4 Oct 2011 21:59:41 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, Sonic Zhang <sonic.zhang@analog.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
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
Message-ID: <20111004205941.GJ19115@trinity.fluff.org>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com> <1316681962-8217-33-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316681962-8217-33-git-send-email-yong.zhang0@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 04:58:59PM +0800, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.

ok, applied thanks.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

