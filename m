Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1KXIJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:09:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1KXIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:09:10 -0500
Subject: Re: linux-next: build failure of Linus' tree
From: Sasha Levin <levinsasha928@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20111124112117.f9abeb7a3f4868be71389372@canb.auug.org.au>
References: <20111124112117.f9abeb7a3f4868be71389372@canb.auug.org.au>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 24 Nov 2011 10:09:05 +0200
Message-ID: <1322122145.4248.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 11:21 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> today's linux-next build of Linus' (x86_64_allmodconfig) failed like this:
> 
> drivers/staging/iio/industrialio-core.c: In function 'iio_event_getfd':
> drivers/staging/iio/industrialio-core.c:262:32: error: 'ev_int' undeclared (first use in this function)
> 
> Caused by commit b46413367961 ("iio: fix a leak due to improper use of
> anon_inode_getfd()").
> 
> I have reverted that commit for today.

I've sent a patch yesterday named "iio: Fix build error in
industrialio-core.c" which should fix that.

-- 

Sasha.

