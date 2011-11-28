Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1K1Lsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:48:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55123 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab1K1Lsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:48:35 -0500
Date: Mon, 28 Nov 2011 11:48:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RESEND 1/2] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
Message-ID: <20111128114832.GA8275@opensource.wolfsonmicro.com>
References: <1322460391.4954.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322460391.4954.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 02:06:31PM +0800, Axel Lin wrote:
> In current implementation, the pointer ri is not NULL if no id is matched.
> Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.

Applied, thanks.
