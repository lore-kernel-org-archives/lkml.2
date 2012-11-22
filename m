Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab2KVUBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:01:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16269 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964983Ab2KVUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:01:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 22 Nov 2012 00:41:15 -0800
Message-ID: <50ADE529.6020000@nvidia.com>
Date: Thu, 22 Nov 2012 14:11:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps80031: Trivial cleanups
References: <1353573044.18426.1.camel@phoenix>
In-Reply-To: <1353573044.18426.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2012 02:00 PM, Axel Lin wrote:
> This patch includes below cleanups:
>
> - Fix typo in comment
> - Fix showing wrong register in dev_err
> - Remove unnecessary rinfo variable
> - Add TPS80032 to MODULE_DESCRIPTION
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>
> ---

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
