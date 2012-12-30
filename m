Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866Ab2L3FcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:32:01 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:46985 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2L3Fb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:31:59 -0500
Date: Sat, 29 Dec 2012 21:32:04 -0800
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: dts: prevent *.dtb from always being rebuilt
Message-ID: <20121230053204.GC20903@quad.lixom.net>
References: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 05:42:46PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> if_changed (used by the *.dts->*.dtc rule) rebuilds files if they aren't
> contained in $(targets). (make V=2 indicates this). Add $(dtb-y) to
> $(targets) to prevent *.dtb from always being rebuilt.
> 
> This fixes a regression introduced by the .dtb rule rework in 499cd82
> "ARM: dt: change .dtb build rules to build in dts directory".
> 
> Reported-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Not sure who you have in mind to apply this, but if it's not through arm-soc:

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
