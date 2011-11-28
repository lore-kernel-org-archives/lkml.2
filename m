Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1K1LtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:49:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55128 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab1K1LtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:49:22 -0500
Date: Mon, 28 Nov 2011 11:49:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: aat2870: Remove a redundant bitwise and
 operation
Message-ID: <20111128114920.GB8275@opensource.wolfsonmicro.com>
References: <1322460391.4954.1.camel@phoenix>
 <1322460468.4954.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322460468.4954.2.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 02:07:48PM +0800, Axel Lin wrote:
> The implementation in aat2870_update() already did the bitwise and operation
> against mask parameter.

Applied, thanks.
