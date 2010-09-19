Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0ISULR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:11:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab0ISULQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 16:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100918010300.0194C403E8@magilla.sf.frob.com>
References: <20100918010300.0194C403E8@magilla.sf.frob.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Sep 2010 13:10:55 -0700
Message-ID: <AANLkTi=5XK69B1hJt7H0Tpa=QE8CQ340voG8oCTWvgkX@mail.gmail.com>
Subject: Re: [PATCH] default CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 6:02 PM, Roland McGrath <roland@redhat.com> wrote:
> The userland ELF tools have been coping with partial-segments core
> files for a few years now.  Multiple distro builds are now setting
> this option.  It behooves everyone who ever deals with core files to
> have more info dumped in there, especially as more and more people's
> compilers are producing build IDs.  Make it the default.

Ok, I can do this next merge window, but it's not appropriate for my tree now.

So either Andrew tracks this, or you'll need to re-send it when we're
not in the -rc phase.

                   Linus
