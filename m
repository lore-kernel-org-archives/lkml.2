Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1C2WuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:50:17 -0400
Received: from mail.perches.com ([173.55.12.10]:4408 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1C2WuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:50:16 -0400
Subject: Re: [PATCH 08/23] fujitsu-laptop: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201103292242.p2TMgAET020124@turbo.physics.adelaide.edu.au>
References: <201103292242.p2TMgAET020124@turbo.physics.adelaide.edu.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 15:50:13 -0700
Message-ID: <1301439013.4113.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 08:12 +0930, Jonathan Woithe wrote:
> what does pr_*() give us over printk()?
 
Consistency in use of prefix.

> I presume it makes it easier to selectively remove certain
> printk levels from the kernel image in the
> name of size reduction.

That's the goal, but there's no support in the
standard kernel for that yet.

It should also in the future make the prefix a
singleton and remove it from the format string
making the image text a bit smaller.

> Some people *may* insist that these long (>80 character) pr_err() lines be
> split so they remain <80 in length.  This was the reason why the original
> printk() call was split like it was.

I don't.
It makes grepping source for strings easier.

cheers, Joe

