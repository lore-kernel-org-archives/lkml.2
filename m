Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0HKMeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 08:34:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:56664 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab0HKMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 08:34:36 -0400
Date: Wed, 11 Aug 2010 08:34:25 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [stable] [116/165] ext4: dont return to
 userspace after freezing the fs with a mutex held
Message-ID: <20100811123425.GP3635@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable-review@kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	stable@kernel.org, alan@lxorguk.ukuu.org.uk
References: <20100730171510.105264205@clark.site>
 <4C56B45E.9010601@canonical.com>
 <4C56FA35.7060607@redhat.com>
 <20100802184806.GA16878@kroah.com>
 <20100807040732.GB16342@khazad-dum.debian.net>
 <4C5D61E7.9090008@redhat.com>
 <4C5FC3BB.4030602@canonical.com>
 <20100810201639.GC12680@kroah.com>
 <4C6265BE.7090509@canonical.com>
 <4C6295A7.4030106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6295A7.4030106@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 08:20:55AM -0400, Eric Sandeen wrote:
> 
> As long as the 2 patches go together it should be fine, I don't
> think there are other significant dependencies.
> 
> It's also not really an urgent one to fix; returning to userspace w/
> a lock held is pretty icky but in practice has not been an actual
> problem AFAIK; most people use lvm to freeze/unfreeze and it all
> gets cleaned up....

Agreed.

I do plan to be uploading stable updates for 2.6.35.x that include the
changes that got pulled for 2.6.35-rc1, and I'll update 2.6.34 and
2.6.32, as well, with 2.6.34 including the updates that somehow didn't
all make it to stable last time.  (I'm thinking about also including
an ftp upload since for some reason some mail server between me at
stable@kernel.org seems to be dropping mail messages when they get
blasted out using git send-email.  :-/ )

I'm at Linuxcon this week though, so I probably won't get to it until
sometime next week.

					- Ted
