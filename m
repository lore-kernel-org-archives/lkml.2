Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab0G3UUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 16:20:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32781 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754693Ab0G3UUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 16:20:06 -0400
Date: Fri, 30 Jul 2010 13:20:18 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Gary King <gking@nvidia.com>
Subject: Re: [PATCH] regulator: tps6586x: fix millivolt return values and
 SM2 table
Message-ID: <20100730202017.GA29726@opensource.wolfsonmicro.com>
References: <1280519938-3089-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280519938-3089-1-git-send-email-mike@compulab.co.il>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 10:58:58PM +0300, Mike Rapoport wrote:
> From: Gary King <gking@nvidia.com>
> 
> Hi Liam,
> Below are bugfixes for the tps6586x spotted by Gary King.
> Please add this patch to your regulator tree.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
