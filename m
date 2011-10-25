Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1JYHXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:23:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48432 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab1JYHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:23:36 -0400
Date: Tue, 25 Oct 2011 09:23:33 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>, gg@slimlogic.co.uk
Subject: Re: [PATCH v2 5/6] mfd: TPS65910: Move regulator defs to header
Message-ID: <20111025072333.GF2919@opensource.wolfsonmicro.com>
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
 <1319475964-10841-6-git-send-email-kyle.manna@fuel7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319475964-10841-6-git-send-email-kyle.manna@fuel7.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 12:06:03PM -0500, Kyle Manna wrote:
> Move the regulator defintions to the header so that platform board file
> can use them to configure specific regulators.
> 
> Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
> ---
>  drivers/regulator/tps65910-regulator.c |   24 ------------------------
>  include/linux/mfd/tps65910.h           |   25 +++++++++++++++++++++++++

Your subject line claims that this is a patch for the mfd but in fact
this is a patch for the regulator driver.  Please use appropriate
subject lines for your patches.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
