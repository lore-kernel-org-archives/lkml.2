Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1I2KW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:22:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57705 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1I2KW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:22:58 -0400
Date: Thu, 29 Sep 2011 11:22:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 4/8] regmap: Guard regcache_sync() with map->lock
Message-ID: <20110929102256.GI3697@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1317289153-21123-4-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317289153-21123-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:39:09AM +0100, Dimitris Papastamos wrote:
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

Ah, you're doing that now.  This and the previous commit should be a
single commit pushing the lock outwards - right now either commit by
itself will break things.
