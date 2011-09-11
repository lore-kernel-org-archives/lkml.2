Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1IKVg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 17:36:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43222 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1IKVg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 17:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <1315383059-3673-37-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	<1315383059-3673-37-git-send-email-yong.zhang0@gmail.com>
Date: Sun, 11 Sep 2011 23:36:25 +0200
Message-ID: <CACRpkdbL2XOPu63r5=twSSs+TvPEvD9S8M7yYAcTP6HJ4MLvJg@mail.gmail.com>
Subject: Re: [PATCH 36/62] i2c: irq: Remove IRQF_DISABLED
From: Linus Walleij <linus.walleij@linaro.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@linux.ie>,
        linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Joe Perches <joe@perches.com>,
        mingo@elte.hu, "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Magnus Damm <damm@opensource.se>, Simon Horman <horms@verge.net.au>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 10:10 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:

> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
