Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1I0TIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:08:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab1I0TIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:08:17 -0400
Date: Tue, 27 Sep 2011 20:08:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 3/5] regmap: Implement generic syncing functionality
Message-ID: <20110927190815.GX4289@opensource.wolfsonmicro.com>
References: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1317119108-15338-4-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317119108-15338-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:25:06AM +0100, Dimitris Papastamos wrote:
> In the absence of a sync callback, do it manually.  This of course
> can't take advantange of the specific optimizations of each
> cache type but it will do well enough in most cases.

Applied, thanks.
