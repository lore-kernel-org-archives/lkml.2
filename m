Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0HRBca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:32:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1142 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0HRBcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:32:23 -0400
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
In-Reply-To: <20100817175851.GA11463@merkur.ravnborg.org>
References: <201008161137.53187.hartleys@visionengravers.com>
	 <20100816231753.GA16546@infradead.org>
	 <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
	 <1282002601.6518.116.camel@Joe-Laptop> <20100817010355.GG21182@thunk.org>
	 <20100817085428.GA25330@infradead.org>
	 <1282065973.24541.106.camel@Joe-Laptop>
	 <20100817175851.GA11463@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 18:32:22 -0700
Message-ID: <1282095142.6724.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 19:58 +0200, Sam Ravnborg wrote:
> It takes minimum effort to create and test, and if you can
> get ack from Ted and/or Christoph there is a good chance Linus
> would take it right before/after -rc1.
> 
> You obviously need to convince him that the patch has
> seen decent build testing.

private_data is the only non f_ prefixed member in
struct file, so while there is perhaps a tiny value
in this patch, I'm not in a hurry to push it.

After a few corrections, Documentation/, comment and
printk updates, a few macros that spatch didn't update,
etc, the diff that converts struct file member
private_data to f_private_data is now:

$ git diff --shortstat ..da5cabf80e2433131bf0ed8993abc0f7ea618c73
 511 files changed, 2638 insertions(+), 2639 deletions(-)

Does either Ted or Christoph want to see it?

Harley?  You want it?

It's still ~850BKB and probably shouldn't be posted to
the ML as it's mostly mechanical.

Compiles x86 allyesconfig, defconfig



