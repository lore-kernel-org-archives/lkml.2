Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1JJJDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:03:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34509 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab1JJJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:03:05 -0400
Date: Mon, 10 Oct 2011 10:03:03 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regmap: Return a sensible error code if we fail to
	read the cache
Message-ID: <20111010090303.GC2563@opensource.wolfsonmicro.com>
References: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 02:44:35PM +0100, Mark Brown wrote:
> If a register isn't cached then let callers know that so they can fall
> back or error handle appropriately.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/regcache-indexed.c |    7 +++----
>  drivers/base/regmap/regcache-lzo.c     |    4 ++--
>  drivers/base/regmap/regcache-rbtree.c  |    3 +--
>  drivers/base/regmap/regcache.c         |    2 +-
>  4 files changed, 7 insertions(+), 9 deletions(-)

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
