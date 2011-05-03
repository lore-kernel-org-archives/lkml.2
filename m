Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1ECRaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:30:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42952 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752784Ab1ECRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:30:13 -0400
Date: Tue, 3 May 2011 18:30:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCH 3/5] TPS65911: Add new irq definitions
Message-ID: <20110503173011.GE1762@opensource.wolfsonmicro.com>
References: <63D42968-AD20-47D2-9AAB-2878EBDBA302@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63D42968-AD20-47D2-9AAB-2878EBDBA302@slimlogic.co.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:18:56AM -0500, Jorge Eduardo Candelaria wrote:

> +	if (tps65910_chip_id(tps65910) == TPS65911) {
> +		tps65910->read(tps65910, TPS65910_INT_STS3, 1, &reg);
> +		irq_sts |= reg << 16;
> +	}

switch statements feel better for future proofing - if your hardware
guys do another design derived from this base you'll need to add another
case in here.
