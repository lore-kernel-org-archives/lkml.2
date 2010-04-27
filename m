Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0D0MGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:06:15 -0400
Received: from lazybastard.de ([212.112.238.170]:51483 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0D0MGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:06:09 -0400
Date: Tue, 27 Apr 2010 14:05:55 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Paolo Minazzi <paolo.minazzi@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
Message-ID: <20100427120554.GG13859@logfs.org>
References: <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org> <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com> <20100427111759.GA13859@logfs.org> <h2h4aa525de1004270431hd98c271ag61462bdb778f7769@mail.gmail.com> <20100427114004.GD13859@logfs.org> <u2u4aa525de1004270454v4da1cb28ld5f2a3e54962f182@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <u2u4aa525de1004270454v4da1cb28ld5f2a3e54962f182@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 April 2010 13:54:09 +0200, Paolo Minazzi wrote:
> 
> Ok, now it is very better.
> My problem now is that logfs does not save files in the following case:
> 1) power-off, then power-on (without umount)
> 2) sync, then power-off, then power-on (without umount)

Ok, I'll have a look.

Can we move this and any other logfs problems to a seperate thread?  I'd
like to leave this one for the sync issues and not spam everyone on Cc:
with unrelated bugs. :)

Jörn

-- 
Don't patch bad code, rewrite it.
-- Kernigham and Pike, according to Rusty
