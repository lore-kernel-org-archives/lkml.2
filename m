Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0IBPbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:31:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60984 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752285Ab0IBPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:30:59 -0400
Date: Thu, 2 Sep 2010 16:30:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/4] sound/soc/fsl/p1022_ds.c: Add of_node_put to avoid
 memory leak
Message-ID: <20100902153056.GE5809@rakim.wolfsonmicro.main>
References: <1283269738-14612-1-git-send-email-julia@diku.dk>
 <1283269738-14612-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283269738-14612-3-git-send-email-julia@diku.dk>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 05:48:56PM +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_parse_phandle.

Applied, thanks.
