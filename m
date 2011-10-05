Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934Ab1JEQXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:23:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59282 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934476Ab1JEQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:23:07 -0400
Date: Wed, 5 Oct 2011 17:23:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Remove unused variable 'wm9090' in wm9090_probe
Message-ID: <20111005162305.GE11528@opensource.wolfsonmicro.com>
References: <1317797235.21481.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317797235.21481.4.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 02:47:15PM +0800, Axel Lin wrote:
> Eliminate below build warning:
>   CC      sound/soc/codecs/wm9090.o
> sound/soc/codecs/wm9090.c: In function 'wm9090_probe':
> sound/soc/codecs/wm9090.c:550: warning: unused variable 'wm9090'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
