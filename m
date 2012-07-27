Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2G0BEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:04:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63647 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2G0BEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120727101535.aa873d14cd8a6736413e9cea@canb.auug.org.au>
References: <20120727101535.aa873d14cd8a6736413e9cea@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jul 2012 18:04:30 -0700
X-Google-Sender-Auth: ZvpRlLWtlVftHqRT0YGSv2XrXnc
Message-ID: <CA+55aFxJjt_vTe4UXhfq7O4r0gCWbAj7FAFrNjpk9Tf0RD86rA@mail.gmail.com>
Subject: Re: linux-next: build failure in Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>,
        David Sterba <dave@jikos.cz>, Arne Jansen <sensille@gmx.net>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alex Lyakas <alex.bolshoy.btrfs@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 5:15 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the origin tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:

Oh well. I did an x86-64 build after that pull (because of the need
for that semantic merge thing), but apparently x86-64 gets the
vmalloc.h indirectly through some other header.

          Linus
