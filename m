Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2IMNK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:10:28 -0400
Received: from 75-15-5-89.uvs.iplsin.sbcglobal.net ([75.15.5.89]:43434 "EHLO
	peff.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab2IMNK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:10:27 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2012 09:10:27 EDT
Date: Thu, 13 Sep 2012 09:03:44 -0400
From: Jeff King <peff@peff.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: [GIT PULL] sound fixes for 3.6-rc6
Message-ID: <20120913130344.GC4287@sigill.intra.peff.net>
References: <s5h392m1728.wl%tiwai@suse.de>
 <CA+55aFyo6do-dZiZMiwZkN1Ko+W58+4-zkbfJnpQR+ufw=+8ig@mail.gmail.com>
 <s5hzk4uyvsr.wl%tiwai@suse.de>
 <s5hvcfiyum4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hvcfiyum4.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 02:28:51PM +0200, Takashi Iwai wrote:

> > FWIW, it was an output from git-pull-request, which fell back to the
> > equivalent branch.  Usually I check it manually but I forgot it at
> > this time just before going to a meeting.
> > 
> > This was with git 1.7.11.5.  I'll check whether this still happens
> > with 1.7.12.
> 
> The same problem still happens with git 1.7.12.
> This is rather annoying than useful.

I can't reproduce here. What is your exact request-pull invocation? Is
request-pull showing a warning like:

  warn: You locally have sound-3.6 but it does not (yet)
  warn: appear to be at git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
  warn: Do you want to push it there, perhaps?

(it should do so since v1.7.11.2). Maybe we need to make it possible to
bump that warning to a fatal error?

-Peff
