Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab0DEXEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:04:32 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:14753 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756816Ab0DEXE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:04:26 -0400
Date: Tue, 6 Apr 2010 00:03:01 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 33/37] sound/soc: use .dev.of_node instead of .node in
 struct of_device
Message-ID: <20100405230301.GF32401@fluff.org.uk>
References: <20100311174830.4824.19820.stgit@angua>
 <20100311180649.4824.10368.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311180649.4824.10368.stgit@angua>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:06:50AM -0700, Grant Likely wrote:
> .node is being removed
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
>  sound/soc/fsl/mpc8610_hpcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
> index ef67d1c..d7e1b9a 100644
> --- a/sound/soc/fsl/mpc8610_hpcd.c
> +++ b/sound/soc/fsl/mpc8610_hpcd.c
> @@ -202,7 +202,7 @@ static struct snd_soc_ops mpc8610_hpcd_ops = {
>  static int mpc8610_hpcd_probe(struct of_device *ofdev,
>  	const struct of_device_id *match)
>  {
> -	struct device_node *np = ofdev->node;
> +	struct device_node *np = ofdev->dev.of_node;
>  	struct device_node *codec_np = NULL;
>  	struct device_node *guts_np = NULL;
>  	struct device_node *dma_np = NULL;

This looks like one case where an inline function would have been a
help.


-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
