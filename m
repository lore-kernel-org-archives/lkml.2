Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0K3PPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:15:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0K3PPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:15:21 -0500
Subject: Re: [PATCH] regulator: Remove duplicate consts from mc13873 driver
 voltage tables
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1291046268-9271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1291046268-9271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 15:15:17 +0000
Message-ID: <1291130117.3293.17.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 15:57 +0000, Mark Brown wrote:
> They're not needed and sparse is verbosely upset about them.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/mc13783-regulator.c |   36 ++++++++++++++++----------------
>  1 files changed, 18 insertions(+), 18 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

