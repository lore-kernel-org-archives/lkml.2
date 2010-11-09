Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0KIKOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:14:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60311 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KIKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:14:15 -0500
Date: Tue, 9 Nov 2010 11:14:06 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Daniel Mack <daniel@caiaq.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH] mxcmmc: update the regulator support code to the
	latest API
Message-ID: <20101109101406.GW16938@pengutronix.de>
References: <1288656337.29881.13.camel@realization> <20101102073932.GB6017@pengutronix.de> <1288949275.3072.3.camel@realization> <1289213595.3425.23.camel@realization> <20101108143746.GA23201@void.printf.net> <1289297390.3020.27.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289297390.3020.27.camel@realization>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:09:50AM +0100, Alberto Panizzo wrote:
> 
> This fix also the build problem introduced by my previous patch
> due to unhanded API changes introduced by
s/handed/handled/ ?

> commit:99fc5131018cbdc3cf42ce09fb394a4e8b053c74
Linus wants to have the commit shortlog for references to other commits.
After doing:

	git config --global alias.one "show -s --pretty='format:%h (%s)'"

once you can simply use the output of

	git one 99fc5131018cbdc3cf42ce09fb394a4e8b053c74

for that.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
