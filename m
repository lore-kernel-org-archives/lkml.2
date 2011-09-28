Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1I1M4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:56:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58910 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab1I1M4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:56:52 -0400
Date: Wed, 28 Sep 2011 13:56:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/7] regmap: Fix regcache_sync generic implementation
Message-ID: <20110928125650.GI3279@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:43:41AM +0100, Dimitris Papastamos wrote:
> We want to use regmap_write() to actually write anything
> to the HW.

Applied, thanks.
