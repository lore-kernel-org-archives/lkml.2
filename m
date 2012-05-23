Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2EWQef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:34:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47093 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2EWQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120523164203.GA7843@S2100-06.ap.freescale.net>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
	<CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
	<20120523084945.GA4085@opensource.wolfsonmicro.com>
	<20120523164203.GA7843@S2100-06.ap.freescale.net>
Date: Wed, 23 May 2012 13:34:32 -0300
Message-ID: <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, marc@cpdesign.com.au,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 1:42 PM, Shawn Guo <shawn.guo@freescale.com> wrote:

> Removing that alone does not resolve the issue, but with additional
> .write_flag_mask setting it does for me.

This is still not working for me on mx31pdk.

Still getting wrong SPI read data from the pmic.
