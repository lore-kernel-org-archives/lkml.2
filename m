Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab2HPQGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:06:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51894 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2HPQGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:06:18 -0400
Message-ID: <502D1A77.2030302@wwwdotorg.org>
Date: Thu, 16 Aug 2012 10:06:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: max8907: Fix n_voltages for MAX8907B SD1
References: <1345091162.14780.0.camel@phoenix>
In-Reply-To: <1345091162.14780.0.camel@phoenix>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:26 PM, Axel Lin wrote:
> For linear voltage mapping, the n_voltages is (max - min) / step + 1

Oh yes:-(

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

