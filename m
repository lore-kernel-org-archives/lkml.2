Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1I1M5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:57:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58912 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135Ab1I1M47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:56:59 -0400
Date: Wed, 28 Sep 2011 13:56:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 2/7] regmap: Modify map->cache_bypass directly
Message-ID: <20110928125657.GJ3279@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1317206627-6673-2-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317206627-6673-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:43:42AM +0100, Dimitris Papastamos wrote:
> In preperation for the upcoming patches, modify map->cache_bypass
> directly.  The helper functions will grab an exclusive lock.  Because
> we'll have acquired the same lock we need to avoid a deadlock.

Applied, thanks.
