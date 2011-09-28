Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1I1MSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:18:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41206 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab1I1MSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:18:36 -0400
Date: Wed, 28 Sep 2011 13:18:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: regcache_rbtree_{set,get}_register: Use
 regcache_{set,get}_val
Message-ID: <20110928121834.GC3279@opensource.wolfsonmicro.com>
References: <1317147338-21492-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317147338-21492-1-git-send-email-lars@metafoo.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 08:15:37PM +0200, Lars-Peter Clausen wrote:
> Use regcache_{set,get}_val in regcache_rbtree_{set,get}_register instead of
> re-implementing its functionality.

Both applied, thanks.
