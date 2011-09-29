Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab1I2KSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:18:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56666 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018Ab1I2KSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:18:15 -0400
Date: Thu, 29 Sep 2011 11:18:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/8] Revert "regmap: Grab the lock in
 regcache_cache_only()"
Message-ID: <20110929101813.GF3697@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:39:06AM +0100, Dimitris Papastamos wrote:
> This reverts commit 38f6916976f9e964748f097be3688e334fb60f3d.

When sending things like this you should always explain what you're
doing and why.  As things are this won't apply since I already fixed
this by using the main lock.
