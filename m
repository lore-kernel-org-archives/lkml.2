Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2LFMpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:45:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2LFMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:45:17 -0500
Date: Thu, 6 Dec 2012 13:45:06 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121206124506.GA4364@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
 <20121204083655.GA21235@fancy-poultry.org>
 <CAPM=9twQZUWBf9FZdAwz5NuaTvfgJSA=bjgHq9rpTMMU3ABRVw@mail.gmail.com>
 <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
 <20121204123522.GA32419@fritha.org>
 <20121204125823.GC11556@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204125823.GC11556@phenom.ffwll.local>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:oRx6dxkfnx29MM7doOuFOFTUTRq6h3mev9XQtRfmO56
 U67hzV8XTOFEnVMMdp3aIlKIIH85bwU6/vuve17ewxKg9IimQy
 hSoJPTbfFomV/dXMIIOtRAuCdcoAlKN1oVrWFj2wyZCTVsoOn/
 Las8Ah118PCgCK7r0XVWcNt27RGGjLeEaCFM+r6awsIN/3gWj7
 0Sp1Ma9cLAmWdU9CWDZhWhqF4mZvlA15LOPdiRLfWS0uqdlERY
 tMe9cax/ZDNQu1+s+nnHANhEtglWsYKuiXzVJXE34PN6O6n7A9
 WiNzVNZQtqjB+8AM1Z6wpUQX893mpA9mCnJElI/mbK4UsimD4H
 0q21PpuETyOUUiJmd1TksLATmQ560LVTBuOQxSEL8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012, Daniel Vetter wrote: 

> Yeah, if anyone can somewhat reliably reproduce this

While writing a big file with dd and watching high resolution videos
on youtube, I've managed to reproduce the hang. Unfortunately, it
doesn't occur within seconds. Some playing around is neccessary, and
it takes between 30 sec. and 20 min.

> > Btw: which kernel is known to be the "last good one"?

> If it's the ilk one we only know that 3.6.x series seems to be solid, and
> something in 3.7-rc (probably before -rc1) broke stuff. So not too useful.

I tried 3.6.9 several times over a few hours and could not trigger the
hang, which clearly adds evidence to this statement. I don't want to
scream out too loud, but 3.6.9 seems not to be affected. Will try
some more hours to get a 3.6.9 box to hang, though.. Just in case..

Heinz
