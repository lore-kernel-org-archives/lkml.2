Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0FIHq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:46:27 -0400
Received: from mail.perches.com ([173.55.12.10]:2866 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0FIHq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:46:26 -0400
Subject: Re: [PATCH 00/12] treewide: Remove unnecessary kmalloc casts
From: Joe Perches <joe@perches.com>
To: Milton Miller <miltonm@bga.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1276068001_13533@mail4.comsite.net>
References: <cover.1275968594.git.joe@perches.com>
	 <96933b66aa5f995746a34410ca63e5e8b84593cb.1275968594.git.joe@perches.com>
	 <1276068001_13533@mail4.comsite.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 00:46:24 -0700
Message-ID: <1276069584.1556.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 02:20 -0500, Milton Miller wrote:
> On Mon Jun 07 2010 at around 23:53:18 EST, Joe Perches wrote:
> > Trivial cleanups
> The reason they casts are present is to guard against someone changing
> the type of p at the top of the function and not changing the type at
> the kmalloc.

That'd be true for most all of the kernel mallocs.

> I know some maintainers have already taken some of
> the series the last time you posted; could you please augment the
> CC list.

I did not send to trivial any of kmalloc cast removal patches that
were acked.  The patches in this series were not acked, so I think
no CC list needs augmentation.

Original: http://lkml.org/lkml/2010/5/31/471
Newest:   http://lkml.org/lkml/2010/6/7/428

cheers, Joe

