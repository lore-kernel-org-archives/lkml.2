Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0GFBLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:11:45 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48612 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab0GFBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:11:44 -0400
X-Sasl-enc: PznTId9U+z7Visqo7BgfAwF8Zfkb5E7Dox8KwBpkrFwu 1278378696
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
From: Ian Kent <raven@themaw.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org
In-Reply-To: <20100705195837.GF5240@nowhere>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
	 <4C3235C3.7050303@zytor.com> <20100705194759.GE5240@nowhere>
	 <201007052152.55954.arnd@arndb.de>  <20100705195837.GF5240@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 09:11:30 +0800
Message-ID: <1278378690.3070.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-05 at 21:58 +0200, Frederic Weisbecker wrote:
> On Mon, Jul 05, 2010 at 09:52:55PM +0200, Arnd Bergmann wrote:
> > On Monday 05 July 2010 21:48:01 Frederic Weisbecker wrote:
> > > On Mon, Jul 05, 2010 at 12:42:59PM -0700, H. Peter Anvin wrote:
> > > > On 07/05/2010 12:24 PM, Frederic Weisbecker wrote:
> > > > > 
> > > > > Peter, if you're fine with this version. May I apply it?
> > > > > Unless you have a tree for autofs.
> > > > > 
> > > > Ian Kent is the maintainer of autofs4 and patches for autofs4 should go
> > > > through him (or acked by him.)
> > > > 
> > > > autofs 3 is officially unmaintained; I'm more than happy to have you
> > > > push the autofs 3 bits of this patch.
> > > 
> > > Sure, I can split up the patch and integrate the autofs 3 part, I'll send
> > > the standalone autofs4 version to Ian.
> > 
> > I think in this case it's really more appropriate to change both autofs3
> > and autofs4 together, to avoid interdependencies. Whichever way Ian
> > prefers (ack the patch or take it) would work though.
> > 
> > 	Arnd
> 
> 
> Yeah indeed. Ian?

As Peter says the autofs module isn't supported anymore and autofs4 will
replace autofs when I eventually get around to re-doing and re-testing
my patch for that.

So it makes no difference whether the patches are combined, if it breaks
autofs then it probably won't be fixed but it may cause the replacement
to happen sooner.

As far as the patch goes that should be fine and we should be able to
remove the BKL from autofs4 soon after but I'm not brave enough to try
just yet.

Ian

