Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab0GQSrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 14:47:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58847 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756536Ab0GQSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 14:47:08 -0400
Date: Sat, 17 Jul 2010 19:47:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sound/soc: davinci: check kzalloc() result (typo)
Message-ID: <20100717184705.GA27456@rakim.wolfsonmicro.main>
References: <1279296977-25267-1-git-send-email-segooon@gmail.com>
 <1279388733.3070.5.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279388733.3070.5.camel@odin>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 06:45:33PM +0100, Liam Girdwood wrote:
> On Fri, 2010-07-16 at 20:16 +0400, Kulikov Vasiliy wrote:
> > The code checks 'davinci_vc' after kzalloc() and do not checks
> > 'davinci_vcif_dev' that kzalloc() result is assigned to. It seems that
> > it is a typo (autocompletion?).

> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

Applied, thanks.  Kulikov could you please check the subject lines
you're using for your patches - try to be consistent with the rest of
the patches for the same code area.
