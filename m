Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0D1RsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:48:20 -0400
Received: from londo.lunn.ch ([80.238.139.98]:32850 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab0D1RsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:48:17 -0400
Date: Wed, 28 Apr 2010 19:47:48 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mark Rankilor <reodge@gmail.com>
Cc: Sven Eckelmann <sven.eckelmann@gmx.de>, gregkh@suse.de, andrew@lunn.ch,
       lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: batman-adv: fixed comments to maintain 80
 char limit
Message-ID: <20100428174748.GE3734@lunn.ch>
References: <1272361449-15416-1-git-send-email-reodge@gmail.com>
 <201004271153.34972.sven.eckelmann@gmx.de>
 <p2p90c96c971004280633t1188db65pd1bbe3679adf4d53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2p90c96c971004280633t1188db65pd1bbe3679adf4d53@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 09:33:40PM +0800, Mark Rankilor wrote:
> On 27 April 2010 17:53, Sven Eckelmann <sven.eckelmann@gmx.de> wrote:
> > Your patch doesn't apply anymore. See
> > 1270341625-28764-1-git-send-email-luisbg@ubuntu.com and follow ups [1].
> 
> I had a look at the follow ups and saw this one:
> 
> https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2010-April/002483.html
> 
> So would it be best if I were to submit patches against the linux-next
> tree? 

Hi Mark

I agree with Greg here. Patches against linux-next are no problem. 

I'm responsible for merging changes in linux-next back into the batman
repo.

Having said that, before deciding to work on something, it probably is
worth looking at the batman repo. There is no point you reproducing
work we have already done, but is just queued up waiting to be sent to
Greg, or is in Gregs backlog of patches to apply.

Basically, i would not bother doing plain checkpatch patches. We are
mostly on top of that and any in linux-next are probably already fixed
in the batman repo.

However if you want to do some work with more meat on it, look for
security problems, memory leaks, race conditions, lockdep etc, such
patches would greatly be appreciated, independent of which repo they
are against.

	Andrew
