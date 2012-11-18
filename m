Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2KREYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 23:24:00 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35906 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2KREX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 23:23:59 -0500
Date: Sat, 17 Nov 2012 20:20:47 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 5/6] power: da9052-battery: Convert to the new da9052
 interrupt functions
Message-ID: <20121118042046.GA18226@lizard.sbx05977.paloaca.wayport.net>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
 <1349320509-26930-5-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349320509-26930-5-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:15:08AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Convert to the new da9052 interrupt functions, so that we can get rid of 
> irq_base references.
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---

It seems that the patch depends on other patches in this series.

I don't see it linux-next, so if anything, for the drivers/power part:

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
