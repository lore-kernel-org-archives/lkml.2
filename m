Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1GNLE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:04:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45258 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754248Ab1GNLE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:04:28 -0400
Date: Thu, 14 Jul 2011 20:04:15 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: wm8900: fix a memory leak if wm8900_set_fll fails
Message-ID: <20110714110413.GB27997@opensource.wolfsonmicro.com>
References: <1310638486.5186.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310638486.5186.1.camel@phoenix>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 06:14:46PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks
