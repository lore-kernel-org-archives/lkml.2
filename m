Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2K2NU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:20:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52400 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2K2NUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:20:55 -0500
Date: Thu, 29 Nov 2012 13:18:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marko =?utf-8?B?S2F0acSH?= <dromede@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] backlight: corgi_lcd: Fix WARN_ON() when calling
	corgi_bl_set_intensity.
Message-ID: <20121129131824.GJ19440@n2100.arm.linux.org.uk>
References: <1354139201-12834-1-git-send-email-dromede@gmail.com> <001501cdcdf2$b3f8f730$1beae590$%han@samsung.com> <CAHod+Gd3UU7NdRLAAbsX6TUugnjKBwUsDy7yBQzyykuf5GHMVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHod+Gd3UU7NdRLAAbsX6TUugnjKBwUsDy7yBQzyykuf5GHMVQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:09:51PM +0100, Marko Katić wrote:
> Well, the commit message was short because i thought it was a quick
> and obvious fix.

Don't always expect the person who ends up applying your patch to know
what your patch is doing.  Don't expect people who are looking back
through the git history to look at the patch to work out whether your
commit is relevant to them.  I suspect Andrew Morton doesn't know what
a "SCOOP" or "AKITA" is...

Commit messages are there not only to describe the change, but also say
why the change is necessary.  Think about it as your chance to "sell"
the patch.

One good step would be to include the warning message dump from the
kernel (your subject line says you're hitting a WARN_ON so include
that.)  At least then people can see your starting point for the patch.
