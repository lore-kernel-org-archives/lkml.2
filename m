Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1A2Kqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 05:46:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:47914 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1A2Kqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 05:46:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,396,1291622400"; 
   d="scan'208";a="701909030"
Date: Sat, 29 Jan 2011 18:46:33 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] sound, hda_eld: suspicious sizeof() in call to
 snd_print_pcm_bits()
Message-ID: <20110129104633.GA12643@localhost>
References: <alpine.LNX.2.00.1101290132560.6465@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101290132560.6465@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 29, 2011 at 01:40:04AM +0100, Jesper Juhl wrote:

>  	if (a->format == AUDIO_CODING_TYPE_LPCM)
> -		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2 - 8));
> +		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2) - 8);

Good catch!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
