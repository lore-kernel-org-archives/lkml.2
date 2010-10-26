Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab0JZSlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:41:35 -0400
Received: from bar.sig21.net ([80.81.252.164]:55546 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JZSle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:41:34 -0400
Date: Tue, 26 Oct 2010 20:41:23 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: Compat-wireless release for 2010-10-25 is baked
Message-ID: <20101026184123.GA1616@sig21.net>
References: <20101025190358.AEC6840F97@repository3.orbit-lab.org>
 <20101026123552.GA4604@sig21.net>
 <AANLkTimzUKj=C9PxGs1PkQy_KWu0PGKd1zv_m-ZpWaEm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimzUKj=C9PxGs1PkQy_KWu0PGKd1zv_m-ZpWaEm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.7 (--)
X-Spam-21-Report: No, score=-2.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.194,BAYES_20=-0.74 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 08:59:04AM -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 26, 2010 at 5:35 AM, Johannes Stezenbach <js@sig21.net> wrote:
> >
> > I wonder about the different tarballs in
> > http://wireless.kernel.org/download/compat-wireless-2.6/
> >
> > compat-wireless-2010-10-25.tar.bz2
> > compat-wireless-2010-10-25-p.tar.bz2
> > compat-wireless-2010-10-25-pc.tar.bz2
> >
> > Those -p and -pc postfixes are not explained in
> > http://wireless.kernel.org/en/users/Download
> 
> Right, sorry, I haven't updated the docs to add documentation for
> them. First please read:
> 
> http://marc.info/?l=linux-wireless&m=128716953726075&w=2
> 
> -s is for getting and applying pending-stable/ fixes
> -n is for applying the patches linux-next-cherry-picks directory
> -p is for applying the patches on the linux-next-pending directory
> -s is for applying the patches on the crap directory
  -c

> Hope this helps.

Definitively, thank you very much.  Meanwhile I also found
scripts/admin-update.sh in compat-wireless which seems to
generate the release tarballs.

It looks like, if I want to test the latest rt2x00 code, I could
clone git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git,
checkout experimental, and then run admin-update.sh with
GIT_TREE=path/to/rt2x00-experimental.  Right?
Or (maybe better?), clone linux-next, merge rt2x00.git and use
the merged tree as GIT_TREE for admin-update.sh.

But according to
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-October/002175.html
the compat-rt2x00 tarballs seem to be made manually?

Sorry for stupid questions, I want to get into rt2x00 development
but I need to target a stable 2.6.32 kernel and I'm trying to figure
out which git tree to base my work on.


Thanks,
Johannes
