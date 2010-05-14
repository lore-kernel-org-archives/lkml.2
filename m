Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0ENI7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:59:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56659 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0ENI7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:59:31 -0400
Subject: Re: [PATCH] Regulators: ab3100/bq24022: add a missing .owner field
 in regulator_desc
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mattias Wallin <mattias.wallin@stericsson.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1273743181.10563.4.camel@mola>
References: <1273743181.10563.4.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 09:59:25 +0100
Message-ID: <1273827565.3069.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:33 +0800, Axel Lin wrote:
> This patch adds a missing .owner field in regulator_desc, which is used for refcounting.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab3100.c  |   10 ++++++++++
>  drivers/regulator/bq24022.c |    1 +
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 

Applied.

Thanks.

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

