Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2HHOuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:50:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54954 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639Ab2HHOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:50:21 -0400
Date: Wed, 8 Aug 2012 15:50:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] regulator/twl: remove fixed resource handling
Message-ID: <20120808145018.GD24328@opensource.wolfsonmicro.com>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
 <1344437248-20560-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344437248-20560-10-git-send-email-arnd@arndb.de>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:47:26PM +0200, Arnd Bergmann wrote:
> The recent patch 0e8e5c34cf "regulator: twl: Remove references to
> 32kHz clock from DT bindings" removed the only use of the fake
> "CLK32KG" regulator but not the TWL6030_FIXED_RESOURCE and
> twl6030_fixed_resource definitions that are unused otherwise.

I've already got a fix for this in my tree.

Please do also make an effort to use subject lines that match the style
of the subsystem.
