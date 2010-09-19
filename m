Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0ISTbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 15:31:21 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36695 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0ISTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 15:31:20 -0400
Date: Sun, 19 Sep 2010 21:31:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Junio C Hamano <junio@pobox.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
Message-ID: <20100919193118.GA26308@merkur.ravnborg.org>
References: <7vhbhmxyeb.fsf@alter.siamese.dyndns.org> <20100919095419.GC25704@merkur.ravnborg.org> <7v8w2xy4pq.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7v8w2xy4pq.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 11:21:21AM -0700, Junio C Hamano wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> 
> > On Sat, Sep 18, 2010 at 07:25:32PM -0700, Junio C Hamano wrote:
> >> In 60f33b8 (kconfig: get rid of stray a.o, support ncursesw, 2006-01-15),
> >> support to link menuconfig with ncursesw library was added.  To compute
> >> the linker command option -l, we check "libncursesw.{so,a,dylib}" to allow
> >> ncursesw to be used as a replacement ncurses.  However, when checking what
> >> header file to include, we do not check /usr/include/ncursesw directory.
> >> 
> >> Add /usr/include/ncursesw to the list of directories that are checked.
> >> With this patch, on my Debian Lenny box with libncursesw5-dev package but
> >> not libncurses5-dev package, I can say "make menuconfig".
> >> 
> >> Signed-off-by: Junio C Hamano <gitster@pobox.com>
> >
> > Except for the missing patch subject then it looks OK.
> > Suggested subject:
> > kconfig: fix menuconfig on debian lenny
> 
> Sorry, the missing subject really was sloppy of me, and thanks.
> 
> > Add as this is a fix we should Cc: <stable@kerne.org>?
> 
> I don't think the fix deserves to be in stable.  It does not look like
> 60f33b8 made it possible to use ncursesw on a box like mine so the patch
> is not evan an regression-fix.
OK
> 
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Thanks; is it my responsibility to follow-up the thread with identical
> patch with updated Subject and with your Ack, hoping somebody in kbuild
> team would pick it up?

I assume Michal will pick it up anyway - but if you do it would make
it simpler for him to do so.
So no need..

	Sam
