Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1GFGoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:44:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47786 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751836Ab1GFGoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:44:17 -0400
Date: Tue, 5 Jul 2011 23:44:13 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: aat2870: Fix the logic of checking if no
 id is matched in aat2870_get_regulator
Message-ID: <20110706064411.GA10438@opensource.wolfsonmicro.com>
References: <1309923277.26847.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309923277.26847.5.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 11:34:36AM +0800, Axel Lin wrote:
> In current implementation, the pointer ri is not NULL if no id is matched.
> Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.

Both

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
