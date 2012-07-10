Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2GJHqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:46:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2GJHqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:46:40 -0400
Date: Tue, 10 Jul 2012 09:46:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Chris Ball <cjb@laptop.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Boot regression on Mackerel with current mainline
In-Reply-To: <87r4skqe1n.fsf@octavius.laptop.org>
Message-ID: <Pine.LNX.4.64.1207100945090.29825@axis700.grange>
References: <201207031218.24797.rjw@sisk.pl> <Pine.LNX.4.64.1207031336320.29890@axis700.grange>
 <201207031910.24864.rjw@sisk.pl> <Pine.LNX.4.64.1207041125330.21042@axis700.grange>
 <87ipdws1mc.fsf@octavius.laptop.org> <Pine.LNX.4.64.1207100845130.29825@axis700.grange>
 <87r4skqe1n.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:f7zMlrohzW2mZDOEYRYvB5UJMzRBIcAWu/xtHCThvja
 T3LWrhsX16D9ZwRliZFpOo0MDQDIgRWljVev39P1xgzF5Njwn2
 Ilt0HZP8ny3dK1GbydlBFPBBbw6AbHGZQ2ridfUpuOuVvdx254
 D1zm1/kvY3cBcNsouZg26Hb4/DPODd2S2kcVFeiShS18LmpbOh
 9SIpUmbp81IxqG3vaKNgUI4AdPa8YpNGE238JmCFq9uK4kOERt
 j6ocUsc9KfLyhTWyKKuMu31mSk5TH5l5665AFbtyYukxPz9WRV
 3XF68ms0+Vf8UjqAnueS33qLfEz0zPdaQq8gCNVlHqWRJxZt+G
 +zQ01YlN+5mcZrK9t3D2puL4Nj6mIfcxQKIKyvk+5hfiR2a+37
 RhXNPp8i3zjXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Chris Ball wrote:

> Hi Guennadi,
> 
> On Tue, Jul 10 2012, Guennadi Liakhovetski wrote:
> >> > The latter one looks big because of a rename, but with "-M" it's pretty 
> >> > trivial. Chris, do you agree?
> >> 
> >> Is the minimal fix to just add "| IRQF_ONESHOT" to the request_threaded_irq
> >> argument?  If so, I'd rather push just that for 3.5, and I can take care of
> >> having that change appear simultaneously in linux-next so that there aren't
> >> any conflicts.  Is that okay with you?
> >
> > For that you'd have to rebase -next, right? you'd like to do that?
> 
> Yeah, I'm willing to rebase mmc-next for this -- I'd rather send the
> simplest possible fix this late in 3.5-rc, and the rebase is simple.
> Also, this fix is logically distinct from your rename patch.
> 
> I don't think I need you to send anything more, I'll add the initial
> patch adding "| IRQF_ONESHOT", rebase your "extend and rename" patch on
> top of that, push both to mmc-next, and then send the initial patch to
> Linus in a few days.

Great, thanks for taking care of this!

Regards
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
