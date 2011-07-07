Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1GGQyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:54:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36493 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752666Ab1GGQyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:54:39 -0400
Date: Thu, 7 Jul 2011 09:54:36 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: pxa2xx-pcm: remove unused variable 'dai'
Message-ID: <20110707165435.GA17164@opensource.wolfsonmicro.com>
References: <1309958442.4613.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309958442.4613.1.camel@phoenix>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 09:20:42PM +0800, Axel Lin wrote:
> Remove unused variable 'dai' to eliminate below warning.

Applied, thanks.
