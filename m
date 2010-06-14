Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0FNIgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:36:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54107 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0FNIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:36:02 -0400
Date: Mon, 14 Jun 2010 10:35:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ivo Clarysse <ivo.clarysse@gmail.com>, linux-kernel@vger.kernel.org,
       Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: [PATCH] mtd/mxc_nand: remove unused variable
Message-ID: <20100614083557.GB12159@pengutronix.de>
References: <1276498911-28115-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276498911-28115-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:01:51AM +0200, Uwe Kleine-König wrote:
> This fixes:
> 
> 	drivers/mtd/nand/mxc_nand.c: In function 'mxcnd_resume':
> 	drivers/mtd/nand/mxc_nand.c:901: warning: unused variable 'host'
> 
> Removing this variable was missed in 9c14b153e6af.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
This conflicts with Eric's "mxc_nand: fix PM" patch which also solves
this issue. 

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
