Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0KCORA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:17:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33997 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0KCOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:16:58 -0400
Subject: Re: [PATCH] regulator: Staticise mc13783_powermisc_rmw()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1288757284-15812-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1288757284-15812-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:16:54 +0000
Message-ID: <1288793814.3277.52.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 00:08 -0400, Mark Brown wrote:
> It is not used outside this driver so no need to make the symbol global.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/mc13783-regulator.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

