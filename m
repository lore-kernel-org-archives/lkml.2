Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1ADUvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:51:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55106 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1ADUvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:51:21 -0500
Subject: Re: [PATCH] regulator: Assign return value of mc13xxx_reg_rmw to
 ret
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1294070258.3320.4.camel@phoenix>
References: <1294070258.3320.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 20:51:16 +0000
Message-ID: <1294174276.3320.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 23:57 +0800, Axel Lin wrote:
> Otherwise, we will not return error if write to MC13892_SWITCHERS5 failed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/mc13892-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

