Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1KOTXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:23:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53726 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620Ab1KOTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:23:21 -0500
Date: Tue, 15 Nov 2011 19:23:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Do not call regcache_exit from
 regcache_rbtree_init error path
Message-ID: <20111115192318.GA4058@opensource.wolfsonmicro.com>
References: <20111114214304.GI6528@opensource.wolfsonmicro.com>
 <1321360481-17783-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321360481-17783-1-git-send-email-lars@metafoo.de>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:34:40PM +0100, Lars-Peter Clausen wrote:
> Calling regcache_exit from regcache_rbtree_init is first of all a layering
> violation and secondly will cause double frees. regcache_exit will free buffers

Applied, thanks.
