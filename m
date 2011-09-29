Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1I2N0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:26:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54828 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372Ab1I2N0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:26:03 -0400
Date: Thu, 29 Sep 2011 14:26:01 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 4/8] regmap: Guard regcache_sync() with map->lock
Message-ID: <20110929132601.GB10995@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com> <1317289153-21123-4-git-send-email-dp@opensource.wolfsonmicro.com> <20110929102256.GI3697@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929102256.GI3697@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 11:22:56AM +0100, Mark Brown wrote:
> On Thu, Sep 29, 2011 at 10:39:09AM +0100, Dimitris Papastamos wrote:
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> 
> Ah, you're doing that now.  This and the previous commit should be a
> single commit pushing the lock outwards - right now either commit by
> itself will break things.

Aw yes I've thought about it, just wasn't too sure about squashing the
two commits together.  Will fix and re-send.
