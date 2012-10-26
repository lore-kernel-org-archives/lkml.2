Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966282Ab2JZTvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:51:46 -0400
Received: from mail.agmk.net ([91.192.224.71]:57048 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966247Ab2JZTvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:51:45 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Heinz Diehl <htd@fritha.org>
Cc: Martin Peres <martin.peres@labri.fr>, Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lekensteyn <lekensteyn@gmail.com>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Date: Fri, 26 Oct 2012 21:51:37 +0200
Message-ID: <4392132.ui6koSANok@localhost>
User-Agent: KMail/4.9.1 (Linux/3.7.0-rc2-00191-g2ab3f29; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121025180654.GA28920@fritha.org>
References: <1724445.dN2yMEzN6d@localhost> <2097113.JL2tUTAZjM@localhost> <20121025180654.GA28920@fritha.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 of October 2012 20:06:54 Heinz Diehl wrote:
> On 25.10.2012, Paweł Sikora wrote: 
> 
> > what is the reason of loading nouveau driver for laptops 
> > with nvidia optimus and enabling vga switcheroo
> > which doesn't work in such (optimus) cases.
> 
> You can safely compile a kernel without nouveau, your Nvidia 
> card will not be used at all since neither Linux nor the 
> proprietary nvidia driver does support optimus at this time
> (and frankly, I won't buy any further machines with opticrap).
> So having nouveau compiled and loaded seems like a waste of ressources
> in this case.

i've bought this asus laptop mostly for a developer's workstation replacement
(quad-core-i7-avx cpu with integrated gpu, with 12GB ram and 2x500GB hdd).
nvidia's addon is an optional crap :)

> For me it's important to have nouveau working, because I try/use
> Bumblebee and optirun: 
> 
> http://bumblebee-project.org/
> https://fedoraproject.org/wiki/Bumblebee

i'll try to use transformers too :-)

