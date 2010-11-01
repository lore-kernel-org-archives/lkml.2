Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0KAPxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:53:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:35089 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab0KAPxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:53:23 -0400
Date: Tue, 02 Nov 2010 00:52:40 +0900 (JST)
Message-Id: <20101102.005240.44125556.ryusuke@osrg.net>
To: nbowler@elliptictech.com
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.37-rc1
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20101101154717.GA17893@elliptictech.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
	<alpine.LFD.2.00.1011011634240.2566@localhost6.localdomain6>
	<20101101154717.GA17893@elliptictech.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Nov 2010 00:52:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010 11:47:17 -0400, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2010-11-01 16:37 +0100, Thomas Gleixner wrote:
> > On Mon, 1 Nov 2010, Linus Torvalds wrote:
> > > The merge window for 2.6.37 is over, and -rc1 is out there (or will be
> > > soon, as things are uploading from my laptop here in Boston and then
> > > mirroring out)
> > 
> > Did you switch back to tarballs and patches only or is there going to
> > be an update of your git tree in the foreseeable future ?
> 
> Seems that the v2.6.37-rc1 tag is in the git tree, but is not reachable
> from the master branch.  See
> 
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=shortlog;h=v2.6.37-rc1
> 

Yes, it looks like only the master branch hasn't been updated.

we can get -rc1 by 'git fetch --tags'

Ryusuke Konishi
