Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2H1SLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:11:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57069 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760Ab2H1SLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:11:04 -0400
Date: Tue, 28 Aug 2012 11:11:00 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com
Subject: Re: [PATCH 2/6] mfd: palmas switch to linear domain in all cases
Message-ID: <20120828181100.GA8796@opensource.wolfsonmicro.com>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
 <1346154460-20031-3-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154460-20031-3-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:47:36PM +0200, Graeme Gregory wrote:
> Swith the palmas to linear domain in all cases so in future DT and non
> DT cases will work the same.

> With this change we can not use regmap_get_virq internally so no need
> to supply IRQ resources to children so remove those definitions.

This second bit of the comment doesn't follow - regmap_get_virq() works
with any kind of irqdomain.
