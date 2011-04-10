Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1DJPHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:07:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:55163 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1DJPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:07:47 -0400
Date: Sun, 10 Apr 2011 08:07:45 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [trivial PATCH 2/2] arm: mach-u300/gpio: Fix mem_region resource
 size miscalculations
In-Reply-To: <AANLkTika-y8bqaXFp008C28wd_YzmcBm2mj5ZLfxSSSy@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1104081937100.6392@deuxcents.site>
References: <cover.1300909445.git.joe@perches.com> <798d0aea7272beadf2ee838f7aa27f86cfe7f9ba.1300909446.git.joe@perches.com> <AANLkTika-y8bqaXFp008C28wd_YzmcBm2mj5ZLfxSSSy@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Linus Walleij wrote:

> 2011/3/23 Joe Perches <joe@perches.com>:
> 
> > Convert off-by-1 r->end - r->start to resource_size(r)
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Oh man, there was one of these lurking in my own beloved mach-u300.
> How embarrassing. Thanks for catching!
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

As I don't see it in today's linux-next, I have picked it up. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

