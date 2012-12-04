Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2LDMfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:35:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2LDMf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:35:26 -0500
Date: Tue, 4 Dec 2012 13:35:22 +0100
From: Heinz Diehl <htd@fritha.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>, Heinz Diehl <htd@fancy-poultry.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121204123522.GA32419@fritha.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
 <20121204083655.GA21235@fancy-poultry.org>
 <CAPM=9twQZUWBf9FZdAwz5NuaTvfgJSA=bjgHq9rpTMMU3ABRVw@mail.gmail.com>
 <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:VSNCjrXrJ0Z4khmpA1Sm/70H6h+RCm04GxCgE3Hd5Bt
 4tlSOvTteG6XyU3OnY3+2LChPp2hMYrOW+tt8K/eHNaiAiALpS
 41faYq3DXdsNk5OTFANmleqFTaERl90Pt/7+SJPxC5+rA6QkXU
 3gvmbju1klLdfZ9WfhVtuXvotuSZRwojk59r/+oL4QVviIJTZ6
 1IbdudD4DOzthn9n/eWloH5mlg6JjRKaIQ1EKtbaf5vC2utTSH
 4AS8UNFprbIRY2k5YGQgjSKldXhNnQbMLg79KeDBYesiFbdfUL
 nMtb7tPyk06nUANBnGBNRiJ5fbfy8bUanD+tdDglAOycyhTOpw
 swB0/LjTQXNLGvjCXBPOosXdA5SHvbnNlakiaFMsO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012, Daniel Vetter wrote: 

> Yeah, if anyone can somewhat reliably reproduce this

Ok, I see. So the beginning would be to reliably reproduce the the
hang. I have encountered it in any possbile situasjon, both when
watching videos on Youtube and right after booting the machine and
doing absolutely nothing.

I'll try around a little bit and see if I can find something that
triggers this hang. 

Btw: which kernel is known to be the "last good one"?

> (you need to disable rc6 on ilk to not hit another issue which seems much easier to
> hit) 

Ilk? If this stands for "Ironlake": I'm on Sandybridge.

> and bisect it, this would be _very_ much appreciated - we've
> pretty much tested all possible "disable stuff" and "revert random
> patch" we could thing of, and we can't reproduce these hangs no matter
> how hard we bang our heads against this.

Bisecting will be a pain without being able to reproduce
the hang reliably.

> Atm we're trying to come up with ways to dump more debug
> information, >but with no clue whatsoever what's going on that's slow-going.

Is there anything at the moment I can do to help you to get a grip on
this problem? My machine is a Core i5-420M laptop with 4GB RAM (Asus
U45-JC). 

Heinz
