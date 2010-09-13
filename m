Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0IMIZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:25:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60256 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753903Ab0IMIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:25:44 -0400
Date: Mon, 13 Sep 2010 09:25:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Geoff Levand <geoff@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 11/11] sound: Remove pr_<level> uses of KERN_<level>
Message-ID: <20100913082542.GB16606@rakim.wolfsonmicro.main>
References: <cover.1284267142.git.joe@perches.com>
 <27a88f64b5bfec16c8abf5aca89b7a1b7533ecb9.1284267142.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a88f64b5bfec16c8abf5aca89b7a1b7533ecb9.1284267142.git.joe@perches.com>
X-Cookie: Go 'way!  You're bothering me!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 10:10:59PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  sound/ppc/snd_ps3.c         |    2 +-
>  sound/soc/s3c24xx/s3c-dma.c |    3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
