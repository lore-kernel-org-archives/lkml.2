Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1HMJnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 05:43:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56984 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750912Ab1HMJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 05:43:14 -0400
X-Authenticated: #2770290
X-Provags-ID: V01U2FsdGVkX1/u/GwvGgDu3KCNMUCfalQZRqUfER4OalyXxR8Ryp
	CdGfNRY30h0tXR
Date: Sat, 13 Aug 2011 11:44:40 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: s6000-pcm: remove unused variable 'dai'
Message-ID: <20110813094440.GA28577@minime.bse>
References: <1313206376.29596.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1313206376.29596.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 11:32:56AM +0800, Axel Lin wrote:
>  static int s6000_pcm_new(struct snd_soc_pcm_runtime *runtime)
>  {
>  	struct snd_card *card = runtime->card->snd_card;
> -	struct snd_soc_dai *dai = runtime->cpu_dai;
>  	struct snd_pcm *pcm = runtime->pcm;
>  	struct s6000_pcm_dma_params *params;
>  	int res;

Acked-by: Daniel Glöckner <dg@emlix.com>
