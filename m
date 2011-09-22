Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1IVTKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:10:23 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:50209 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1IVTKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:10:20 -0400
Date: Thu, 22 Sep 2011 13:10:19 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Abhilash K V <abhilash.kv@ti.com>
cc: linux-omap@vger.kernel.org, "Maupin, Chase" <chase.maupin@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        aneesh@ti.com, khilman@ti.com, santosh.shilimkar@ti.com,
        christian.gmeiner@gmail.com
Subject: Re: [PATCH v4 1/3] AM35x: Using OMAP3 generic hwmods
In-Reply-To: <1316697993-696-2-git-send-email-abhilash.kv@ti.com>
Message-ID: <alpine.DEB.2.00.1109221303530.10719@utopia.booyaka.com>
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com> <1316697993-696-2-git-send-email-abhilash.kv@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Chase

Hi

On Thu, 22 Sep 2011, Abhilash K V wrote:

> This patch enables AM35x SoCs to use generic OMAP3 hwmods
> (i,e. omap3xxx_hwmods) by allowing am35xx_init_early() to
> disable the modules which are not present in AM3517.
> 
> Reviewed-by: Sanjeev Premi <premi@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

We now use a different approach for registering hwmods that are 
device-specific.  Could you please take a look at the approach that's in 
Tony's master branch and use it instead to handle AM3517 hwmod 
registration?

- Paul
