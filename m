Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2AWXm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:42:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46776 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2AWXmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:42:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Power management fixes for 3.3
Date: Tue, 24 Jan 2012 00:46:24 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <201201232244.19379.rjw@sisk.pl> <CA+55aFyDo34V5qtFPq5XQgZicFOeU7t6eEzuvbx20FS2+CwCNw@mail.gmail.com>
In-Reply-To: <CA+55aFyDo34V5qtFPq5XQgZicFOeU7t6eEzuvbx20FS2+CwCNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201240046.24894.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 24, 2012, Linus Torvalds wrote:
> On Mon, Jan 23, 2012 at 1:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > (this actually is a signed tag, which I've tried to use for the first time
> > ever, but hopefully it's OK).
> 
> Looks fine. In the future, I'd suggest not adding things that are
> computable to the tag message (ie shortlog and diffstat). They don't
> really add any new information, unlike your own commentary.

Well, right.

> I edited those parts out from the merge message (it's still accessible
> in the hidden tag information, of course, since the tag message is
> part of what gets covered by the signature).

Thanks a lot and sorry for the additional work.

Rafael
