Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2FZKwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:52:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48982 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2FZKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:52:05 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340707652-29329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340707652-29329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 26 Jun 2012 18:51:45 +0800
Message-ID: <CAF+7xWk_Unkg5hTbYLkuTD7DQbWgC1XXcLd96CXgyUmC3b07nQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Check for failed voltage sets before
 checking for delay
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> There is no need to consider waiting for the voltage to ramp if we
> didn't manage to set it and looking at the return value is going to be
> cheaper than is_enabled().
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Axel Lin <axel.lin@gmail.com>
