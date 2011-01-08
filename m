Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1AHODw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:03:52 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:59212 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1AHODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:03:50 -0500
Date: Sat, 8 Jan 2011 15:03:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Message-ID: <20110108140347.GA3928@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110108130427.GA25461@merkur.ravnborg.org> <20110109004539.5bf33510.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109004539.5bf33510.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 12:45:39AM +1100, Stephen Rothwell wrote:
> Hi Sam,
> 
> On Sat, 8 Jan 2011 14:04:27 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > -LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
> > +LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
> > +                   -Iarch/$(hrd-arch)/include/generated -Iinclude \
>                                ^^^
> hdr-arch?
Good spotted.

I wonder how this slipped in?!?

If anyone try this - then please fix the misspelling.
I will repost patch later.

	Sam
