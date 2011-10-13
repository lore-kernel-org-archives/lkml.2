Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1JMLP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:15:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1JMLP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:15:27 -0400
Date: Thu, 13 Oct 2011 12:15:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: ak4535: fixup cache register table
Message-ID: <20111013111525.GG5193@opensource.wolfsonmicro.com>
References: <1318497427.2857.14.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318497427.2857.14.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 05:17:06PM +0800, Axel Lin wrote:
> ak4535_reg should be 8bit, but cache table is defined as 16bit.

Applied, thanks.
