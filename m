Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2FMP32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:29:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43782 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2FMP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <1339594736-6712-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1339594736-6712-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 12:27:57 -0300
Message-ID: <CAOMZO5DvEfou+6QUyd_AiygwQA9QvYnb6izuHZyfKJQ-z4JZNQ@mail.gmail.com>
Subject: Re: [PATCH] regmap: Remove warning on stubbed dev_get_regmap()
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 10:38 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> It's perfectly sensible to ask if there's a regmap for a device which
> doesn't have one so the stubbed version shouldn't complain, the caller
> should be prepared for this.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks,

Fabio Estevam
