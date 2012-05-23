Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2EWGsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:48:46 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37359 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2EWGso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:48:44 -0400
Date: Wed, 23 May 2012 08:49:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sean Paul <seanpaul@chromium.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, daniel@ffwll.ch,
        jbarnes@virtuousgeek.org
Subject: Re: Regression on GMA965 - display seems to have slow jump changes
 in brightness
Message-ID: <20120523064941.GA5062@phenom.ffwll.local>
Mail-Followup-To: Sean Paul <seanpaul@chromium.org>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, jbarnes@virtuousgeek.org
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
 <20120522123058.GB4629@phenom.ffwll.local>
 <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
 <20120522144443.GD4629@phenom.ffwll.local>
 <CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
 <CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com>
 <CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOw6vbKOss-h8A2yRRunCKv7RUnD6QV4Pj1Rg8+2YC5qBKL8pQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 06:21:22PM -0400, Sean Paul wrote:
> On Tue, May 22, 2012 at 6:15 PM, Zdenek Kabelac
> <zdenek.kabelac@gmail.com> wrote:
> > 2012/5/22 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > And we have a winner - cec2f356d59d9e070413e5966a3c5a1af136d948
> >
> 
> Hmm, seems like your display doesn't like to be downclocked, or rather
> you don't like it to be downclocked :) The reason this patch triggered
> it is because it does a better job of finding a compatible clock. You
> can disable lvds downclocking on the kernel command line by setting
> i915.lvds_downclock=0

... which is actually the default. Zdenek, are you enabling this option on
your kernel cmdline?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
