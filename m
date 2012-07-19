Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab2GSE22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:28:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GSE20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:28:26 -0400
Date: Thu, 19 Jul 2012 05:28:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
Subject: Re: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
Message-ID: <20120719042824.GW31729@ZenIV.linux.org.uk>
References: <5006491D.8070004@t-online.de>
 <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
 <20120718212044.GU31729@ZenIV.linux.org.uk>
 <CA+55aFyHpgbJ9Pn5xn_ALkvzjQBOWog2qLbwwtrKbPHSGpa6pA@mail.gmail.com>
 <20120718213355.GV31729@ZenIV.linux.org.uk>
 <CA+55aFx_soQ2sKAcY0yhSFOchkjH55Kvu=jTUW0PJLNxRk9rGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx_soQ2sKAcY0yhSFOchkjH55Kvu=jTUW0PJLNxRk9rGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 03:37:52PM -0700, Linus Torvalds wrote:
> On Wed, Jul 18, 2012 at 2:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >  The only questions
> > are "is this the WARN_ON() Knut had stepped on" (and I agree with your
> > scenario now) and "is it critical enough to shove it into the tree
> > less than a week before -final".  Up to you...
> 
> 
> I agree that it isn't critical. Even the lockdep thing is just a
> warning, and is apparently quite hard to trigger.
> 
> Will you hold on to the patch in your VFS tree, and we can just merge
> it for 3.6?

Sure, no problem...
