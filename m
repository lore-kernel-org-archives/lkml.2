Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2LGFUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 00:20:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57714 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442Ab2LGFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 00:20:23 -0500
Date: Fri, 7 Dec 2012 14:20:03 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8788-ldo: Remove val array in
 lp8788_config_ldo_enable_mode
Message-ID: <20121207052002.GF26070@opensource.wolfsonmicro.com>
References: <1354844877.13831.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354844877.13831.1.camel@phoenix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 09:47:57AM +0800, Axel Lin wrote:
> To clear the mask bit, setting data argument to be 0 with proper mask setting
> for lp8788_update_bits. We don't need the var array here.

Applied, thanks.
