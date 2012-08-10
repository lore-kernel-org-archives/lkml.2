Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2HJQ5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:57:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45444 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab2HJQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:57:15 -0400
Date: Fri, 10 Aug 2012 17:57:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jerry Snitselaar <dev@snitselaar.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, perex@perex.cz,
        tiwai@suse.de
Subject: Re: [PATCH] ASoC: core: remove unused variable in soc_probe() in
 linux-next
Message-ID: <20120810165711.GK24328@opensource.wolfsonmicro.com>
References: <1344579386-27193-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344579386-27193-1-git-send-email-dev@snitselaar.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 11:16:26PM -0700, Jerry Snitselaar wrote:
> With commit 28d528c8 "ASoC: core: Remove pointless error on card
> registration failure", the variable ret is no longer used in
> soc_probe() and generates an unused variable warning during a build.

Applied, thanks.
