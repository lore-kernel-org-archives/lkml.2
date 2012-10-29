Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab2J2MVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:21:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab2J2MVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:21:06 -0400
Subject: Re: [PATCH v5 3/4] misc: sram: Add optional clock
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CAP=VYLo6CRg9goGivS6h0avfP6cqQZzvsTEGQp=Ky3npmtxcDg@mail.gmail.com>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
	 <1350570453-24546-4-git-send-email-p.zabel@pengutronix.de>
	 <CAP=VYLo6CRg9goGivS6h0avfP6cqQZzvsTEGQp=Ky3npmtxcDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 13:20:59 +0100
Message-ID: <1351513259.5872.105.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 26.10.2012, 11:18 -0400 schrieb Paul Gortmaker:
> On Thu, Oct 18, 2012 at 10:27 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > On some platforms the SRAM needs a clock to be enabled explicitly.
> 
> Since this is a file that you've just created in the previous commit,
> I don't see why this needs to exist as a standalone commit, vs just
> being folded back into the previous commit?

you are right, I'll do that.

thanks
Philipp

