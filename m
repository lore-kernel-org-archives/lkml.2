Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab2AKVxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:53:18 -0500
Received: from relais.videotron.ca ([24.201.245.36]:26710 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2AKVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:53:16 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 11 Jan 2012 16:53:15 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Junio C Hamano <gitster@pobox.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
In-reply-to: <CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1201111648240.2722@xanadu.home>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
 <CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
 <7vty438575.fsf@alter.siamese.dyndns.org> <201201111812.46431.arnd@arndb.de>
 <CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Geert Uytterhoeven wrote:

> On Wed, Jan 11, 2012 at 19:12, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> [...]
> 
> > Now let's assume that all dependencies are merged upstream already
> > and I just want to send out three pull requests. The first
> > pull request generally works fine, though it could be that some
> > version of git in the past would include the diff between v3.3-rc2
> > and v3.3-rc4 in the diffstat. For the second pull request, I merge
> > v3.3 with A and send do 'git request-pull B origin
> > tmp-merge-of-upstream-and-A'. This seems to generate the correct
> > list of patches, but the wrong diffstat (diffstat also contains
> > the diff between v3.3-rc4 and v3.3-rc5, although that is indeed
> > part of tmp-merge-of-upstream-and-A. For submitting branch C,
> > I have to merge upstream, A, B and the dependencies together
> > and then send a pull request against that. This typically also
> > includes the external dependencies in the diffstat.
> 
> <throwing the bat in the hen house, no idea if this expression exists
> in other languages than Dutch>
> And all of this would look nice if you would have done a rebase on top of the
> latest tagged version of Linus' tree that contains all prerequisites, right?
> </throwing...>

No, because as a maintainer merging other people's branches, you're not 
supposed to rebase anything.  Linus did flame maintainers doing that in 
the past.  The reason is that by rebasing you modify the environment in 
which the changes are applied which voids the testing that the original 
author did.


Nicolas
