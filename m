Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0D0LkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:40:20 -0400
Received: from lazybastard.de ([212.112.238.170]:56294 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab0D0LkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:40:16 -0400
Date: Tue, 27 Apr 2010 13:40:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Paolo Minazzi <paolo.minazzi@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
Message-ID: <20100427114004.GD13859@logfs.org>
References: <20100423205518.GB7008@logfs.org> <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org> <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com> <20100427111759.GA13859@logfs.org> <h2h4aa525de1004270431hd98c271ag61462bdb778f7769@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <h2h4aa525de1004270431hd98c271ag61462bdb778f7769@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 April 2010 13:31:11 +0200, Paolo Minazzi wrote:
> 
> > If you add "rootfstype=romfs" to the command line, does the problem
> > still exist?
> 
> Jorn , you are right.
> It seems work....
> please wait....

Ok, I'm pretty sure that logfs returns -EIO where it should return
-EINVAL.  If filesystems are tried in alphabetical order, logfs comes
first and -EIO tells the kernel to stop trying and panic, essentially.

Will cook up a patch...

Jörn

-- 
A defeated army first battles and then seeks victory.
-- Sun Tzu
