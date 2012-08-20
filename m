Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2HTPBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:01:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33004 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2HTPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:01:43 -0400
Message-ID: <50325153.3000305@wwwdotorg.org>
Date: Mon, 20 Aug 2012 09:01:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: max8907: Properly set pmic pointer in max8907_regulator_remove()
References: <1345271585.7986.0.camel@phoenix>
In-Reply-To: <1345271585.7986.0.camel@phoenix>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2012 12:33 AM, Axel Lin wrote:
> Add missing platform_get_drvdata() call in max8907_regulator_remove(), this
> fixes below build warning:
> 
>   CC [M]  drivers/regulator/max8907-regulator.o
> drivers/regulator/max8907-regulator.c: In function 'max8907_regulator_remove':
> drivers/regulator/max8907-regulator.c:353:23: warning: 'pmic' is used uninitialized in this function [-Wuninitialized]

That's odd; while this warning and the patch are obviously correct, I
can't get my compiler to warn about it at all, and it usually is pretty
strict about emitting warnings. Oh well.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

