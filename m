Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0CaMIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:08:22 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:60641 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab0CaMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:08:21 -0400
Date: Wed, 31 Mar 2010 14:08:16 +0200
From: Nikolaus Schulz <microschulz@web.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Marton Balint <cus@fazekas.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kevin Dankwardt <k@kcomputing.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fat: fix buffer overflow in vfat_create_shortname()
Message-ID: <20100331120816.GA3430@penelope.zusammrottung.local>
References: <20100325035010.GA3242@penelope.zusammrottung.local>
 <8739zp6k9s.fsf@devron.myhome.or.jp>
 <20100325122419.GA8896@luigi.zusammrottung.local>
 <87y6hg60nw.fsf@devron.myhome.or.jp>
 <87bpec4l8j.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpec4l8j.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V01U2FsdGVkX1/otLYPCbs/LYaGVFxtDlFpQxezqd/54sRsosge
	5r0Xo+PVvRhyoxAcnwzeLWKZNzbRxleL2Ahh7yn18IFh+jmMVf
	xIZ7MYLUE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 09:52:12PM +0900, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> > Nikolaus Schulz <microschulz@web.de> writes:
> >
> >>> However, anyway, your patch is much better off than current one. So,
> >>> I'll apply this in the next merge window.
> >>> 
> >>> Or should we apply this immediately?
> >>> 
> >>> Thanks.
> >>
> >> Given that this fixes a stack corruption which triggers the gcc stack
> >> smashing protection and thus basically a crash, I vote for not
> >> postponing it, but applying it immediately.
> >
> > Um..., where is a stack corruption? sprintf() overflow? But, it's
> > actually snprintf(), not sprintf()...
> 
> Whoops, it was really sprintf().

Ping?

I really think this should go into 2.6.34 and the next stable kernel
updates.

Nikolaus
