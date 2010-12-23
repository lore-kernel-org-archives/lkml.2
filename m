Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0LWLME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:12:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51331 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0LWLMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:12:02 -0500
Date: Thu, 23 Dec 2010 20:11:56 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the sound tree with the s5p tree
In-reply-to: <s5hk4j0n43g.wl%tiwai@suse.de>
To: "'Takashi Iwai'" <tiwai@suse.de>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jassi Brar'" <jassi.brar@samsung.com>
Message-id: <004001cba292$3827d2d0$a8777870$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcuikQsTjpyuh7ByQAOAvq5HWHtwKgAAEFrQ
References: <20101223115339.1ce18216.sfr@canb.auug.org.au>
 <003f01cba28c$872214f0$95663ed0$%kim@samsung.com>
 <s5hk4j0n43g.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> At Thu, 23 Dec 2010 19:31:12 +0900,
> Kukjin Kim wrote:
> >
> > Stephen Rothwell wrote:
> > >
> > > Hi Takashi,
> > >
> > > Today's linux-next merge of the sound tree got a conflict in
> > > sound/soc/samsung/smdk_wm8580.c sound/soc/samsung/smdk_wm9713.c
between
> > > commit 7ca825bed699c77b218ead402202df384556950b ("ASoC: Samsung:
Rename
> > > DMA device") from the s5p tree and various commits from the sound
tree.
> > >
> > > I used the versions from the sound tree that seemed to be supersets of
> the
> > > ones from the s5p tree.
> >
> > Merry Xmas Stephen :-)
> >
> > Thanks for your information.
> >
> > As I said to Mark, I did 'cherry-pick' following 2 commits in my tree
for
> > avoiding build error from sound-2.6.git.
> > I couldn't 'merge' into my tree because there is no suitable branch in
your
> > tree...
> >
> > --
> >
> > commit 83e37b8e400ca51cc97946815b3055daacd92fa8
> > Author: Jassi Brar <jassi.brar@samsung.com>
> > Date:   Mon Nov 22 15:35:53 2010 +0900
> >
> >     ARM: Samsung: Define common audio-dma device
> >
> >     The ASoC uses common DMA driver for Audio devices. So it makes
> >     sense to a common audio-dma device shared across all platforms.
> >
> >     Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
> >     Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> >     Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
> >     Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > commit 58bb4072132c54d832082cc6eac396a6db009cbd
> > Author: Jassi Brar <jassi.brar@samsung.com>
> > Date:   Mon Nov 22 15:35:50 2010 +0900
> >
> >     ASoC: Samsung: Rename DMA device
> >
> >     Some Samsung SoCs have a PCM(DSP) controller. So the name
> >     s3c24xx-pcm-audio for DMA driver is not very appropraite.
> >     This patch moves :-
> >         s3c24xx-pcm-audio -> samsung-audio
> >
> >     Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
> >     Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> >     Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
> >     Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > --
> >
> > Maybe happened conflict from latter commit.
> >
> > Anyway I need above commits from sound-2.6.git in my tree...
> > so how method is better to me instead of cherry-pick it?
> 
> You can merge topic/asoc branch of sound git tree.
> This brach contains the all necessary commits for ASoC and is almost
> never rebased.

Hi,

But I can't merge it because there is no 'topic/asoc' branch in
sound-2.6.git.
(git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git)

Is there another repository?

And should I merge it in my tree even though don't need all of ASoC commits
:-( ?
I'm not sure how many commits are in there...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

