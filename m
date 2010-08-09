Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0HIBvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 21:51:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53855 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab0HIBvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 21:51:03 -0400
Message-ID: <4C5F5F01.2090802@kernel.dk>
Date: Sun, 08 Aug 2010 21:50:57 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20100809112831.0dc41e76.sfr@canb.auug.org.au>
In-Reply-To: <20100809112831.0dc41e76.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2010 09:28 PM, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/block/xen-blkfront.c: In function 'blkif_release':
> drivers/block/xen-blkfront.c:1238: error: label 'out' used but not defined
> 
> Caused by commit acfca3c622a009fb62b566604452ab9fb3a11019 ("blkfront:
> Remove obsolete info->users").  I assume something went wrong in the
> rebase ...
> 
> I have used the block tree from next-20100807 for today.

Oops, fixed up.

-- 
Jens Axboe

