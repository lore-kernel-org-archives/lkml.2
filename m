Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2EWDZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:25:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43724 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755487Ab2EWDZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:25:13 -0400
Message-ID: <1337743509.13111.27.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org,
        apw@canonical.com
Date: Tue, 22 May 2012 20:25:09 -0700
In-Reply-To: <4FBC505A.9000102@gmail.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1337288048.17726.64.camel@joe2Laptop>
	 <20120517211641.GC27953@pcarmody2.research.nokia.com>
	 <4FBC4372.5070000@gmail.com> <1337738520.13111.17.camel@joe2Laptop>
	 <4FBC505A.9000102@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 12:50 +1000, Ryan Mallon wrote:
[]
>   #define __videocard struct card_info
>     __attribute__((section(".videocards")))
> I'm guessing is because typedefs don't handle __attribute__.

Probably not and likely it shouldn't be
either a define or a typedef.

It's just not frequently used enough.

Maybe it could be more like
DEFINE_PCI_DEVICE_TABLE though that's
not pretty either.

> We could test for lots of things in checkpatch, but it seems more
> sensible to check for issues which are likely.

Maybe, but being comprehensive isn't
necessarily bad either.

Look at __setup, all the <foo>_ops tests,
the blackfin tests, etc. in checkpatch.

I don't care much one way or another.

Again, if Andrew or Andy wants to push it
forward, it's fine by me.

cheers, Joe

