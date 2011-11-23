Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1KWOX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:23:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37153 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1KWOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:23:28 -0500
Subject: Re: [PATCH] iio: Fix build error in industrialio-core.c
From: Sasha Levin <levinsasha928@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
In-Reply-To: <20111123141727.GA3195@mwanda>
References: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
	 <20111123141727.GA3195@mwanda>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 23 Nov 2011 16:21:14 +0200
Message-ID: <1322058074.3581.25.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 17:17 +0300, Dan Carpenter wrote:
> On Wed, Nov 23, 2011 at 12:13:59PM +0200, Sasha Levin wrote:
> > The error was introduced in commit b4641336 ("iio: fix a leak due to
> > improper use of anon_inode_getfd()").
> > 
> 
> Which tree is that patch from?  It's not in linux-next.
> 
> regards,
> dan carpenter

It's in Linus's tree:
https://github.com/torvalds/linux/commit/b46413367961c2e8bd827e067a231be982aaeee2

Which explains why sfr didn't complain about it earlier.

-- 

Sasha.

