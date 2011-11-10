Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1KJRlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:41:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48061 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab1KJRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:41:45 -0500
Date: Thu, 10 Nov 2011 17:41:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix memory leak in regmap_init error path
Message-ID: <20111110174135.GA32341@opensource.wolfsonmicro.com>
References: <1320945315-2745-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320945315-2745-1-git-send-email-lars@metafoo.de>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 06:15:15PM +0100, Lars-Peter Clausen wrote:
> If regcache initialization fails regmap_init will currently exit without
> freeing work_buf.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied, thanks.
