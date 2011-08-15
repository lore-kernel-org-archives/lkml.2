Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1HONIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:08:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57179 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752209Ab1HONIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:08:39 -0400
Date: Mon, 15 Aug 2011 22:08:29 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH 1/3] regulator: tps65910: fix device initialisation
Message-ID: <20110815130827.GC3927@opensource.wolfsonmicro.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:45:25PM +0200, Johan Hovold wrote:
> Fix regression introduced by commit
> a320e3c3d6351814afa5182159df88d2637e0f6f (regulator: tps65911: Add new
> chip version) which broke probe for all devices:
> 
> 	"Invalid tps chip version"

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
