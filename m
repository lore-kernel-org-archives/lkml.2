Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1EDPLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:11:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50025 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1EDPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:11:44 -0400
Date: Wed, 4 May 2011 17:11:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: oskar.andero@sonyericsson.com
Cc: nicolas.pitre@linaro.org,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Boivie, Victor" <Victor.Boivie@sonyericsson.com>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110504151140.GJ11574@pengutronix.de>
References: <1302255383-12375-1-git-send-email-oskar.andero@sonyericsson.com>
 <20110504150352.GA19335@caracas.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110504150352.GA19335@caracas.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oskar,

On Wed, May 04, 2011 at 05:03:52PM +0200, oskar.andero@sonyericsson.com wrote:
> Ping.
> 
> On 11:36 Fri 08 Apr, oskar.andero@sonyericsson.com wrote:
> > From: Victor Boivie <victor.boivie@sonyericsson.com>
> > 
> > This patch allows the provided CONFIG_CMDLINE to be concatenated
> > with the one provided by the boot loader. This is useful to
> > merge the static values defined in CONFIG_CMDLINE with the
> > boot loader's (possibly) more dynamic values, such as startup
> > reasons and more.
> > 
> > Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
> > Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> > Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Acked-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> > ---
It can probably go to Russell's patch system[1].

Best regards
Uwe

[1] http://www.arm.linux.org.uk/developer/patches/

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
