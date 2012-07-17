Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2GQH2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:28:46 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36342 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab2GQH2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:28:45 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Dan Williams <dan.j.williams@gmail.com>
CC: Marek Vasut <marex@denx.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: [PATCH V2] [SCSI] async: Fixup arguments of
 async_synchronize_full_domain in alsa-soc
Thread-Topic: [PATCH V2] [SCSI] async: Fixup arguments of
 async_synchronize_full_domain in alsa-soc
Thread-Index: AQHNY6DddwIU6+nPDk68NeP/NNuNBJcs+rCAgACO9AA=
Date: Tue, 17 Jul 2012 07:28:38 +0000
Message-ID: <1342510116.3039.5.camel@dabdike.int.hansenpartnership.com>
References: <1342477026-8376-1-git-send-email-marex@denx.de>
	 <CAA9_cmcWaj_KWLz1m0sxCJNihVuGMQsbP53=1cPiEBBWiei7bg@mail.gmail.com>
In-Reply-To: <CAA9_cmcWaj_KWLz1m0sxCJNihVuGMQsbP53=1cPiEBBWiei7bg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [87.194.65.0]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF04A8B95988B84897A776DDA14BB20E@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6H7SqbC032658

On Mon, 2012-07-16 at 15:56 -0700, Dan Williams wrote:
> On Mon, Jul 16, 2012 at 3:17 PM, Marek Vasut <marex@denx.de> wrote:
> [..]
> >  sound/soc/soc-dapm.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > V2: CC proper people, hopefully proper mailing list
> >     Adjust the patch subject with proper tags
> >
> > diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> > index eded657..e491eb0 100644
> > --- a/sound/soc/soc-dapm.c
> > +++ b/sound/soc/soc-dapm.c
> > @@ -1572,7 +1572,7 @@ static int dapm_power_widgets(struct snd_soc_dapm_context *dapm, int event)
> >         struct snd_soc_dapm_context *d;
> >         LIST_HEAD(up_list);
> >         LIST_HEAD(down_list);
> > -       LIST_HEAD(async_domain);
> > +       ASYNC_DOMAIN_EXCLUSIVE(async_domain);
> >         enum snd_soc_bias_level bias;
> >
> 
> Thanks.  This was folded into the resend that was submitted week [1]

OK, I missed that with the cockup in the cover letters.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
