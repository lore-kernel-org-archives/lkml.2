Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2D1B4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 21:56:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59846 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758346Ab2D1B43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 21:56:29 -0400
X-Sasl-enc: ghdV2g/Svl18xEXug8zVhTNAAABZmD9vHzb5VE3zSZD6M7ZpvnlSzV++UQ 1335578187
Message-ID: <1335578184.4141.9.camel@perseus.themaw.net>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: Ian Kent <raven@themaw.net>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, thomas@m3y3r.de,
        stable@kernel.org
Date: Sat, 28 Apr 2012 09:56:24 +0800
In-Reply-To: <20120427.151433.1007849975903946491.davem@davemloft.net>
References: <20120427.143402.1028957981042061092.davem@davemloft.net>
	 <CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
	 <CA+55aFyLk-uPMVaic19YOWdvdj2pv4R+E3s7UQ6voAy6UkO_Sg@mail.gmail.com>
	 <20120427.151433.1007849975903946491.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 15:14 -0400, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 27 Apr 2012 11:55:12 -0700
> 
> > On Fri, Apr 27, 2012 at 11:42 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> There's no question that systemd is broken.
> > 
> > Actually, I'll take that back.
> > 
> > Yes, systemd has breakage. But it's actually automount that is the
> > truly broken piece of sh*t.
> > 
> > I think that 'automount' is even more broken. The fact that the
> > automount maintainers knew about this, and added TOTALLY BROKEN code
> > to their automount source tree, over five years ago, because the
> > authors clearly did not understand what the f*ck they were doing,
> > that's the real problem.
> 
> I respectfully disagree.
> 
> It's ugly as shit, but it is the only one place where one can be
> absolutely sure that we are dealing with a pipe passing those v5
> things around.
> 
> All these hacks we have been talking about, assuming the mount means
> the pipe is for passing structure so-and-so around, and now trying
> to find some other check such as one on current->comm...
> 
> That's better?
> 
> Only the application really knows.  And I bet the person who wrote
> that automountd code you find so distasteful analyzed this and came
> to realize how difficult the kernel side would be to get right.

There's nothing I can say in my defense, Linus has made that very clear,
over and again.

When I realized the alignment mistake there were already shipping
binaries so I decided it was too late to change that.

And I see I got the analysis of the architectures alignment wrong, mmmm,
that's bad as well.

I guess I'll just be quiet now since anything I say is probably going to
be wrong.

Ian


