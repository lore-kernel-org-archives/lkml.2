Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161834Ab2CPU6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:58:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031888Ab2CPU6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:58:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Date: Fri, 16 Mar 2012 20:57:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com> <201203161218.05125.arnd.bergmann@linaro.org>
In-Reply-To: <201203161218.05125.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203162057.58706.arnd@arndb.de>
X-Provags-ID: V02:K0:U2WW33MoXXYfUA3aZR5/fc69MuIIXIic7oLJwxJTl65
 PkFfQf7Aw5FjQkYOxeXaOlGiDIYugMk1wQ9hewxb6mFmC1wlkX
 eLENZTlWHsNBYTi0tokboKd2oXMDHq4q0zGQKtlMT6FZ1MsSRV
 IgcWuF1KVMP5501DfwQ+s9wyuW0yU+sw06zVyNt12RqIoUno/z
 EzV1NPRCmb2Sq1Q96JOjZtBR7mXiAWLgszHnJGVTPLsapDHApd
 L3ixDuM+7DbiKc5BuH8l0yiCDZj47gXIvOVVlxTBdNrJGjp7Fw
 JcOA9s/hMBuljtz9bJBLFQoPyTm4oLAv8XCqCfO7LMtvbSBBJ9
 rm7P2gsBSTc+EgMTVT80=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012, Arnd Bergmann wrote:
> > 
> > Can we shoe-horn this thing into 3.4 (it is a bit late, i know) so
> > that platform ports can gather speed? Several people are waiting for a
> > somewhat stable version before starting their ports.
> > 
> > And what is the path into mainline - will Russell carry it or Arnd
> > (with Russell's blessing)?
> 
> I would suggest putting it into a late/* branch of arm-soc so it finally
> gets some linux-next exposure, and then sending it in the second week of the
> merge window.
> 
> Russell, please let me know if you want to carry it instead or if you
> have found any last-minute show stoppers in the code.

FWIW, it's in arm-soc now, and it's the last thing I  put in there
for v3.4. From now on until v3.4-rc1, feature patches can only get
removed from arm-soc, not added.

	Arnd
