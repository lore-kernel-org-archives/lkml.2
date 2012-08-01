Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2HANyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:54:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51985 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab2HANyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:54:18 -0400
Date: Wed, 1 Aug 2012 14:54:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] regmap: Don't lock in regmap_reinit_cache()
Message-ID: <20120801135416.GV11892@opensource.wolfsonmicro.com>
References: <1343397255-31163-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343397255-31163-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 02:54:15PM +0100, Dimitris Papastamos wrote:
> When bus->fast_io is set, the locking here is done with spinlocks.
> This is currently true for the regmap-mmio bus implementation.

Applied, thanks.
