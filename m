Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1KVTbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:31:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48531 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KVTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:31:08 -0500
Date: Tue, 22 Nov 2011 19:30:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v3 0/5] common clk framework
Message-ID: <20111122193057.GA20179@sirena.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <20111122154259.GA18954@kroah.com>
 <20111122174544.GA19739@n2100.arm.linux.org.uk>
 <CAPtuhTgFPZA9U-8heNw1eNUnHLFv2w+LzXg5rdjSx3J53Xy+2g@mail.gmail.com>
 <20111122191226.GA4844@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122191226.GA4844@kroah.com>
X-Cookie: Baby On Board.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:12:26AM -0800, Greg KH wrote:
> On Tue, Nov 22, 2011 at 10:09:29AM -0800, Mike Turquette wrote:

> > If others also agree that it should reside only in debugfs then I'll
> > move it there for V4.

> If it's only for debug stuff, then yes, it belongs in debugfs.  All
> distros turn debugfs on these days, and for an embedded system, the code
> is quite small so there should not be much overhead.

Most of the embedded distros included, there's too much useful stuff in
there.
