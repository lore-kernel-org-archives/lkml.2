Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1HONJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:09:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57192 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752333Ab1HONJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:09:34 -0400
Date: Mon, 15 Aug 2011 22:09:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH 2/3] regulator: tps65910: fix list_voltage for VDD1 and
 VDD2
Message-ID: <20110815130910.GD3927@opensource.wolfsonmicro.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
 <1313405127-2724-2-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313405127-2724-2-git-send-email-jhovold@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:45:26PM +0200, Johan Hovold wrote:
> Fix regression introduced by commit
> a320e3c3d6351814afa5182159df88d2637e0f6f (regulator: tps65911: Add new
> chip version) which broke list_voltage for VDD1 and VDD2.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Why is this a separate patch to the previous one?
