Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1C3WjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:39:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab1C3WjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:39:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
Date: Thu, 31 Mar 2011 00:39:33 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
References: <201103292143.12777.rjw@sisk.pl> <201103302355.38136.rjw@sisk.pl> <AANLkTiksT50imm3yQJPrRTqp732=jNYqnNdyvGhGbyHQ@mail.gmail.com>
In-Reply-To: <AANLkTiksT50imm3yQJPrRTqp732=jNYqnNdyvGhGbyHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103310039.34128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 31, 2011, Linus Torvalds wrote:
> On Wed, Mar 30, 2011 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > That, in fact, is not necessary.  Moreover, it turns out that the patch size
> > is not much different, because only a few subsystems use CONFIG_HIBERNATION
> > directly.
> >
> > The patch below has only been slightly tested, in particular I'd like the Xen
> > people to check if it works for them.
> 
> Ok, this seems to make much more sense. Just from a quick scan, the
> places where you changed things to
> 
>   #ifdef CONFIG_HIBERNATE_CALLBACKS
> 
> really do seem to be about the freeze/thaw callbacks. So now the patch
> looks more logical to me. And it obviously doesn't change the
> user-visible questions.
> 
> Thank you,

Thanks for the review!

@Shriram: Can you please test if the new patch works with your other Xen
patches?

Rafael
