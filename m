Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0KHOh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:37:59 -0500
Received: from void.printf.net ([89.145.121.20]:42434 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab0KHOh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:37:58 -0500
Date: Mon, 8 Nov 2010 14:37:46 +0000
From: Chris Ball <cjb@laptop.org>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage
	the MMC card voltage
Message-ID: <20101108143746.GA23201@void.printf.net>
References: <1288656337.29881.13.camel@realization> <20101102073932.GB6017@pengutronix.de> <1288949275.3072.3.camel@realization> <1289213595.3425.23.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289213595.3425.23.camel@realization>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alberto,

On Mon, Nov 08, 2010 at 11:53:15AM +0100, Alberto Panizzo wrote:
> > > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Chris,
> Please, any comment on this one?

This is pushed to mmc-next and queued for 2.6.38 now.  Thanks!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
