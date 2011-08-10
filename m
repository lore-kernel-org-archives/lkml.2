Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1HJLZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:25:22 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42251 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1HJLZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:25:21 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 07:25:20 EDT
Date: Wed, 10 Aug 2011 13:15:42 +0200
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Julia Lawall <julia@diku.dk>, Jaroslav Kysela <perex@perex.cz>,
        kernel-janitors@vger.kernel.org, Andreas Mohr <andi@lisas.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/pci/azt3328.c: adjust error handling code to
 include debugging code
Message-ID: <20110810111542.GA5881@rhlx01.hs-esslingen.de>
References: <1312969744-29659-1-git-send-email-julia@diku.dk>
 <s5hk4albni7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk4albni7.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 10, 2011 at 11:54:08AM +0200, Takashi Iwai wrote:
> At Wed, 10 Aug 2011 11:49:04 +0200,
> Julia Lawall wrote:
> > 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > snd_azf3328_dbgcallenter is called at the very beginning of the function,
> > so it could be useful to call snd_azf3328_dbgcallleave at all exit points.
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Applied now to sound git tree.  Thanks.

5 minutes, 4 seconds. Your responsiveness appears to be degrading. I've
seen better ;)

JFTR:
Acked-by: Andreas Mohr <andi@lisas.de>

Andreas Mohr
