Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2A2V35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 16:29:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57152 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973Ab2A2V34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 16:29:56 -0500
Date: Sun, 29 Jan 2012 21:29:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Add devm_regulator_put in consumer.h
Message-ID: <20120129212951.GB2994@opensource.wolfsonmicro.com>
References: <1327830757.16989.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327830757.16989.1.camel@phoenix>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 05:52:37PM +0800, Axel Lin wrote:
> Commit d5ad34f7cb "regulator: Implement devm_regulator_free()"
> actually implements devm_regulator_put.
> Thus rename devm_regulator_free to devm_regulator_put.

Applied, thanks.
