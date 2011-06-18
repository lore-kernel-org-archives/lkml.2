Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab1FRRhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:37:40 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37507 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750839Ab1FRRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:37:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EIHU8wiOh46bjVRopZ3fyT6VAc5YsVm8KXvAHKWMGMcmh9MaLDO5QJmsAoYcjswQXc34bxH6r+8ySWcb2i00zCcRRL2AecdbGvg+39hJonEwYjzaN8CLJVhH1OtchLyy;
Date: Sat, 18 Jun 2011 10:37:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hughd@google.com
Subject: Re: [PATCH] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
Message-Id: <20110618103737.c6d95512.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.02.1106181331490.5909@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6>
	<20110618192847.62dc6d87@stein>
	<alpine.DEB.2.02.1106181331490.5909@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011 13:32:14 -0400 (EDT) Robert P. J. Day wrote:

> On Sat, 18 Jun 2011, Stefan Richter wrote:
> 
> > On Jun 18 Robert P. J. Day wrote:
> > > +	  If you've selected TMPFS, you almost certainly want this option
> > > +	  as well since a number of user space features (ie., ALSA sound)
> > > +	  require POSIX ACL support under /dev to work properly.  In other
> >
> > There are still many systems which do not use ACLs in /dev or anywhere
> > else at all.  Hence, "may require POSIX ACL support".
> >
> > > +	  words, if you're not sure and you have no *compelling* reason to
> > > +	  deselect this feature, say Y.
> >
> > The asterisks around compelling are unnecessary.

agreed.

>   ok, i can reword and resubmit if you like.

yes, please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
