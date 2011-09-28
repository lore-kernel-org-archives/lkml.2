Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1I1KJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:09:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50457 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376Ab1I1KJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:09:16 -0400
Date: Wed, 28 Sep 2011 11:09:13 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: rbtree-cache: Move cached rbnode handling
	into lookup function
Message-ID: <20110928100913.GA1605@opensource.wolfsonmicro.com>
References: <1317147338-21492-1-git-send-email-lars@metafoo.de> <1317147338-21492-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317147338-21492-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 08:15:38PM +0200, Lars-Peter Clausen wrote:
> Move the handling of the cached rbnode into regcache_rbtree_lookup. This allows
> us to remove of some duplicated code sections in regcache_rbtree_read and
> regcache_rbtree_write.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
 
Both look good to me.

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
