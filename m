Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1HONx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:53:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44701 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753621Ab1HONxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:53:25 -0400
Date: Mon, 15 Aug 2011 22:53:16 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-pcm: Remove unused global mutex
Message-ID: <20110815135313.GD5890@opensource.wolfsonmicro.com>
References: <1313280012.4112.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313280012.4112.2.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 08:00:12AM +0800, Axel Lin wrote:
> Since commit b8c0dab9bf3373010e857a8d3f1b594c60a348dd
> "ASoC: core - PCM mutex per rtd",
> the global pcm_mutex is not being used any more.

Applied, thanks.
