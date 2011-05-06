Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1EFJiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:38:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57551 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755347Ab1EFJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:38:24 -0400
Date: Fri, 6 May 2011 10:38:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Move VCOINCELL to be the last element of
 mc13892_regulators array
Message-ID: <20110506093822.GC23729@opensource.wolfsonmicro.com>
References: <1304609578.5296.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304609578.5296.4.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 11:32:58PM +0800, Axel Lin wrote:
> In include/linux/mfd/mc13892.h, we define MC13892_VCOINCELL as 23.
> Thus VCOINCELL should be defined as 23th element in mc13892_regulators array, not the first one.
> This actually fixes an off-by-one bug while accessing mc13892_regulators array.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
