Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0ITX46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:56:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52675 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0ITX45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:56:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Kara <jack@suse.cz>
Subject: Re: [Bug #16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Tue, 21 Sep 2010 01:55:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera> <aRnAGz9xZ8K.A.wgG.uA8lMB@chimera> <20100920212955.GB14020@quack.suse.cz>
In-Reply-To: <20100920212955.GB14020@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009210155.53218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010, Jan Kara wrote:
> On Mon 20-09-10 21:57:17, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
>   The patch is in block tree, going to 2.6.37 and then -stable trees.

OK, thanks for the update.

The bug is going to be listed, though, until 2.6.36 is released.

Rafael
