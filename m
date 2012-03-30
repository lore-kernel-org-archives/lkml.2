Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab2C3BUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 21:20:41 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:50609 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2C3BUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 21:20:36 -0400
Date: Fri, 30 Mar 2012 10:20:34 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: regression(?) 3.3-rc4 -> 3.3-rc5: drm intel hangs
Message-ID: <20120330012034.GI6277@gamma.logic.tuwien.ac.at>
References: <20120228040327.GA9973@gamma.logic.tuwien.ac.at> <20120228083248.GA4249@phenom.ffwll.local> <20120309080741.GC7149@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120309080741.GC7149@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

is there anything else I can provide?

On Fr, 09 Mär 2012, Norbert Preining wrote:
> Hi everyone,
> 
> currently 3.3.0-rc6+  I just was hit by that after wake up from ram:
> 
> On Di, 28 Feb 2012, Daniel Vetter wrote:
> > > Feb 28 11:42:47 mithrandir kernel: [15627.756071]
> > > [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> > > Feb 28 11:42:47 mithrandir kernel: [15627.756087] [drm] capturing error
> > > event; look for more information in /debug/dri/0/i915_error_state
> > 
> > Wee need this i915_error_state file from debugfs (you might need to mount
> > that first again) to diagnose gpu hangs. Also, it only contains
> > information after a crash, so you need to rehang your machine if you've
> > rebooted since then.
> 
> Now I could get that file from debugfs, and the dmesg output with
> proper debug value.
> 
> Attached are both.

I think I have sent everything that I can send. The problem happens
now again and again, but no pattern. Of course, *always* after
resume from RAM.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`...and the Universe,' continued the waiter, determined
not to be deflected on his home stretch, `will explode
later for your pleasure.'
Ford's head swivelled slowly towards him. He spoke with
feeling.
What sort of drinks do you serve in this
place?'
The waiter laughed a polite little waiter's laugh.
I think sir has perhaps misunderstood me.'
`Oh, I hope not,' breathed Ford.
                 --- Ford in paradise.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
