Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1AHOHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:07:43 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:59509 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1AHOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:07:41 -0500
Date: Sat, 8 Jan 2011 15:07:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 01/12] unicore32 core architecture: build
	infrastructure
Message-ID: <20110108140740.GB3928@merkur.ravnborg.org>
References: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn> <201101070118.41900.arnd@arndb.de> <023801cbaf15$8c569690$a503c3b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <023801cbaf15$8c569690$a503c3b0$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Overall, I can see that there has been a lot of good progress in the code since
> > the original versions that I looked at, very nice!
> > 
> > > diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
> > > new file mode 100644
> > > index 0000000..f0fc866
> > > --- /dev/null
> > > +++ b/arch/unicore32/.gitignore
> > > @@ -0,0 +1,70 @@
> > > +#
> > > +# Generated include files
> > > +#
> > > +include/asm/atomic.h
> > > +include/asm/auxvec.h
> > > +include/asm/bitsperlong.h
> > > +include/asm/bug.h
> > > +include/asm/bugs.h
> > > +include/asm/cputime.h
> > > +include/asm/current.h
> > > +include/asm/device.h
> > > +include/asm/emergency-restart.h
> > > +include/asm/errno.h
> > > +include/asm/fb.h
> > > +include/asm/fcntl.h
> > > +include/asm/hardirq.h
> > > ...
> > 
> > Maybe it would be better to put these files into a separate directory, like
> > arch/unicore32/include/generated/asm, to make it easier to separate them
> > from the other files and avoid listing them all in .gitignore besides the
> > other places.
> 
> That's great, and I make the following changes:
...

I have made a second attempt to provice generic support
for asm-generic headers as you likely have seen.

IMO you shall keep your own solution until we get
generic support.
In other words - you shall avoid being dependent on this.

	Sam
