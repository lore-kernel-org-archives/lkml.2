Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2GQIwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:52:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51214 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2GQIww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:52:52 -0400
From: Marek Vasut <marex@denx.de>
To: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH V2] [SCSI] async: Fixup arguments of async_synchronize_full_domain in alsa-soc
Date: Tue, 17 Jul 2012 09:50:34 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Dan Williams <dan.j.williams@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>
References: <1342477026-8376-1-git-send-email-marex@denx.de> <CAA9_cmcWaj_KWLz1m0sxCJNihVuGMQsbP53=1cPiEBBWiei7bg@mail.gmail.com> <1342510116.3039.5.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342510116.3039.5.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207170950.34351.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear James Bottomley,

> On Mon, 2012-07-16 at 15:56 -0700, Dan Williams wrote:
> > On Mon, Jul 16, 2012 at 3:17 PM, Marek Vasut <marex@denx.de> wrote:
> > [..]
> > 
> > >  sound/soc/soc-dapm.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > V2: CC proper people, hopefully proper mailing list
> > > 
> > >     Adjust the patch subject with proper tags
> > > 
> > > diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> > > index eded657..e491eb0 100644
> > > --- a/sound/soc/soc-dapm.c
> > > +++ b/sound/soc/soc-dapm.c
> > > @@ -1572,7 +1572,7 @@ static int dapm_power_widgets(struct
> > > snd_soc_dapm_context *dapm, int event)
> > > 
> > >         struct snd_soc_dapm_context *d;
> > >         LIST_HEAD(up_list);
> > >         LIST_HEAD(down_list);
> > > 
> > > -       LIST_HEAD(async_domain);
> > > +       ASYNC_DOMAIN_EXCLUSIVE(async_domain);
> > > 
> > >         enum snd_soc_bias_level bias;
> > 
> > Thanks.  This was folded into the resend that was submitted week [1]
> 
> OK, I missed that with the cockup in the cover letters.

Well, the main point is it's now fixed. Thanks guys! :-)

> James

Best regards,
Marek Vasut
