Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0FCMpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:45:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58277 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0FCMp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:45:29 -0400
To: Jens Axboe <jaxboe@fusionio.com>
CC: miklos@szeredi.hu, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <4C0793F6.4070107@fusionio.com> (message from Jens Axboe on Thu,
	03 Jun 2010 13:37:26 +0200)
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 	<20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> 	<20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> 	<20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com> 	<20100603070126.GJ3564@kernel.dk> <AANLkTilwyuE-HiY0vX5askTNi1KoeuKIldmE85WrfIqU@mail.gmail.com> 	<AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com> 	<4C078610.6020901@fusionio.com> <AANLkTinhO5oRDPXyXaeAOZU3i55eBKsx4iFMOzwm98na@mail.gmail.com> <AANLkTin_8MU3AbJ_KeXr2uTxtRFJ5ABmBAyigU6m-C6u@mail.gmail.com> <4C078E2B.7090107@fusionio.com> <E1OK8fK-0007Wa-BU@pomaz-ex.szeredi.hu> <4C0793F6.4070107@fusionio.com>
Message-Id: <E1OK9nN-0007gB-LB@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Jun 2010 14:45:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010, Jens Axboe wrote:
> On 2010-06-03 13:32, Miklos Szeredi wrote:
> > On Thu, 03 Jun 2010, Jens Axboe wrote:
> >> I looked at that when I did the original pipe-max-pages, but it seems
> >> we're not consistent in this regard. Anyway, here's what I came up with.
> >> Not tested yet, and I hope thunderbird doesn't fsck up the patch.
> > 
> > Unfortunately it did (line wrap damage).
> 
> I suspected it might. This better?

Still strips spaces at the end of lines.

But bigger problem is, I don't know what this patch is against.
Doesn't apply cleanly against latest git.

Thanks,
Miklos
