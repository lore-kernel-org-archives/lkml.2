Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1FCLLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:11:13 -0400
Received: from twin.jikos.cz ([89.185.236.188]:43230 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab1FCLLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:11:10 -0400
Date: Fri, 3 Jun 2011 13:10:49 +0200
From: David Sterba <dave@jikos.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: dave@jikos.cz, Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kreijack@libero.it
Subject: Re: linux-next: build warninga in Linus' tree
Message-ID: <20110603111048.GR12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Mitch Harder <mitch.harder@sabayonlinux.org>,
	dave@jikos.cz, Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kreijack@libero.it
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
 <20110531175709.GC12709@twin.jikos.cz>
 <BANLkTi=t5H8sAc_0sHyFt_xJgbeVibO3KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=t5H8sAc_0sHyFt_xJgbeVibO3KQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 10:16:48AM -0500, Mitch Harder wrote:
> I've been playing around with resurrecting the basic sysfs
> capabilities that had been previously incorporated into btrfs.
> 
> As it stands right now, it was relatively easy to re-implement sysfs
> as it was originally.  However, that implementation of sysfs wasn't
> populated with much information (only total_blocks, blocks_used, and
> blocksize).

Goffredo Baroncelli (CCed) posted a patch to enhance sysfs interface:

https://patchwork.kernel.org/patch/308902/
(http://www.spinics.net/lists/linux-btrfs/msg06777.html)

> I also had to reverse a small portion of code that was in the last
> clean-up.

Restoring the code should not be a problem, the cleanup was too eager
and I think a sysfs inteface would be good, not only for debugging
purposes or tuning.

> If a CONFIG_BTRFS_DEBUG type configuration flag is ever introduced, it
> would be interesting to resurrect btrfs' sysfs capabilities.

Hearing about CONFIG_BTRFS_DEBUG again, seems worth to add it.


david
