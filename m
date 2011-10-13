Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1JMKwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:52:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59020 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab1JMKwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:52:00 -0400
Date: Thu, 13 Oct 2011 11:51:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Johannes Stezenbach <js@sig21.net>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: sta32x: Write the register default value to cache
 for reserved registers
Message-ID: <20111013105158.GD5193@opensource.wolfsonmicro.com>
References: <1318488008.2857.1.camel@phoenix>
 <1318489051.2857.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318489051.2857.3.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 02:57:31PM +0800, Axel Lin wrote:
> Chip documentation explicitly requires that the reset values
> of reserved register bits are left untouched.

Applied, but this seems really wierd - shouldn't we just be getting this
stuff from the cache defaults?  Why do we explicitly need to write to
the cache?
