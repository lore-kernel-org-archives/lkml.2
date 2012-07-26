Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2GZBd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:33:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64184 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GZBd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:33:26 -0400
Date: Wed, 25 Jul 2012 20:33:22 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: Cleanup stale __NFDBITS and related
 definitions
Message-ID: <20120726013322.GB3532@burratino>
References: <20120725144033.GK10534@zod.bos.redhat.com>
 <1343258796.5132.164.camel@deadeye.wl.decadent.org.uk>
 <20120726012713.GA2356@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726012713.GA2356@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Josh Boyer wrote:

> Indeed.  However, I believe Linus pointed out that even before
> 8b3d1cda4f5f the macros that were removed weren't actually used.
> It's likely safe to go back further than just 3.4.
>
> I'll verify again in the morning and include the furthest back we could
> remove these.  For now, let's go with what you suggest to be safe.

I may be in the minority in having this view or missing a subtlety,
but shouldn't the question be the furthest back we need to remove
these rather than the furthest back we could?

Thanks,
Jonathan
