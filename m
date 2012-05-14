Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2ENMnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:43:08 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:36679 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab2ENMnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:43:06 -0400
Message-ID: <1336999380.4898.1.camel@odin>
Subject: Re: [PATCH] regulator: core: Don't open code _regulator_is_enabled()
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 13:43:00 +0100
In-Reply-To: <1336998178-5229-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336998178-5229-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 13:22 +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Acked-by: Liam Girdwood <lrg@ti.com>

