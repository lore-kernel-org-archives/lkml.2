Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1ELGaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:30:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35705 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919Ab1ELGaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:30:24 -0400
Date: Thu, 12 May 2011 08:30:25 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Fix desc_id for tps65023/6507x/65910
Message-ID: <20110512063025.GC15372@opensource.wolfsonmicro.com>
References: <1305179270.11113.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305179270.11113.3.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 01:47:50PM +0800, Axel Lin wrote:
> The desc_id variable should not be a static variable.
> 
> The rest of the code assumes the desc_id must less than TPSxxxxx_NUM_REGULATOR.
> If we set desc_id to be a static variable, checking the return value of
> rdev_get_id() may return error.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
