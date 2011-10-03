Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab1JCVOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:14:48 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:58798 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932653Ab1JCVOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:14:36 -0400
Date: Mon, 3 Oct 2011 14:14:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] PCH reference clock cleanups
Message-ID: <20111003141423.0ff5447c@jbarnes-desktop>
In-Reply-To: <CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
	<1317103906-4649-1-git-send-email-keithp@keithp.com>
	<CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011 15:22:48 -0300
Paulo Zanoni <przanoni@gmail.com> wrote:

> 2011/9/27 Keith Packard <keithp@keithp.com>:
> > Here's a patch sequence which cleans up a bunch of PCH refclk related
> > bits.
> 
> For the series: Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
> 
> Tested all the patches on Ironlake (LVDS + VGA). Fixes fd.o bug #38750 for me.
> 
> I also tested the patch you sent today 1 hour ago (inline in one of
> the emails) and things still work with it. I'll keep using these
> patches since they fix my laptop. Any problem will be reported.
> 
> Maybe my email client/server is ruining things, but I believe patch 7
> includes whitespace errors.

Yay excellent.

Now... is keeping the various refclks enabled costing us any power?
IOW, should we be trying to disable them when everything has been
DPMS'd off too?

-- 
Jesse Barnes, Intel Open Source Technology Center
