Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab1EDQKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:10:23 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18032 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab1EDQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:10:22 -0400
From: <oskar.andero@sonyericsson.com>
Date: Wed, 4 May 2011 18:10:18 +0200
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
CC: "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Boivie, Victor" <Victor.Boivie@sonyericsson.com>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110504161018.GA19897@caracas.corpusers.net>
References: <1302255383-12375-1-git-send-email-oskar.andero@sonyericsson.com>
 <20110504150352.GA19335@caracas.corpusers.net>
 <20110504151140.GJ11574@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110504151140.GJ11574@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:11 Wed 04 May     , Uwe Kleine-K?nig wrote:
> Hello Oskar,
> 
> On Wed, May 04, 2011 at 05:03:52PM +0200, oskar.andero@sonyericsson.com wrote:
> > Ping.
> > 
> > On 11:36 Fri 08 Apr, oskar.andero@sonyericsson.com wrote:
> > > From: Victor Boivie <victor.boivie@sonyericsson.com>
> > > 
> > > This patch allows the provided CONFIG_CMDLINE to be concatenated
> > > with the one provided by the boot loader. This is useful to
> > > merge the static values defined in CONFIG_CMDLINE with the
> > > boot loader's (possibly) more dynamic values, such as startup
> > > reasons and more.
> > > 
> > > Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
> > > Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
> > > Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> > > Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > > Acked-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> > > ---
> It can probably go to Russell's patch system[1].
Thanks! That one was new to me!

-Oskar
