Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1LSGI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:08:26 -0500
Received: from ozlabs.org ([203.10.76.45]:38499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab1LSGH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:07:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 13/15] module_param: make bool parameters really bool (sound)
In-Reply-To: <s5hiplim2tt.wl%tiwai@suse.de>
References: <87boraserb.fsf@rustcorp.com.au> <s5hiplim2tt.wl%tiwai@suse.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 19 Dec 2011 12:25:40 +1030
Message-ID: <8762hdpboj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 13:33:50 +0100, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 15 Dec 2011 13:49:36 +1030,
> Rusty Russell wrote:
> > 
> > module_param(bool) used to counter-intuitively take an int.  In
> > fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> > trick.
> > 
> > It's time to remove the int/unsigned int option.  For this version
> > it'll simply give a warning, but it'll break next kernel version.
> > 
> > Cc: Jaroslav Kysela <perex@perex.cz>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Cc: alsa-devel@alsa-project.org
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Acked-by: Takashi Iwai <tiwai@suse.de>
> 
> (Maybe it'd be good to change with true and false instead of 1 and 0,
>  too.  But it's subtle things and we don't have to mix up in a single
>  patch.)
> 
> Rusty, would you like to merge from your tree, or shall I merge
> through sound tree?

Please take it :)

I'll take the bint one, since that's got other dependencies, but this
one is pure cleanup.

Thanks!
Rusty.
