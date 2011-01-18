Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1AREfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:35:45 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36904 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1AREfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:35:42 -0500
Date: Tue, 18 Jan 2011 13:33:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de,
        jbarnes@virtuousgeek.org, dmitry.torokhov@gmail.com, dtor@mail.ru,
        rubini@cvml.unipv.it, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: Request for unicore32 architecture codes to merge into linux-next
Message-ID: <20110118043323.GF2122@linux-sh.org>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 01:00:31AM +0800, Guan Xuetao wrote:
>  drivers/staging/puv3/Kconfig                  |  125 ++
>  drivers/staging/puv3/Makefile                 |   22 +
>  drivers/staging/puv3/TODO                     |    7 +
>  drivers/staging/puv3/i8042-ucio.h             |   89 ++
>  drivers/staging/puv3/puv3-atkbd.h             |   43 +
>  drivers/staging/puv3/puv3_ac97.c              |  369 +++++
>  drivers/staging/puv3/puv3_i2c.c               |  309 ++++
>  drivers/staging/puv3/puv3_pcm.c               |  435 ++++++
>  drivers/staging/puv3/puv3_pcm.h               |   28 +
>  drivers/staging/puv3/puv3_umal.c              | 2069 +++++++++++++++++++++++++
>  drivers/staging/puv3/puv3_unifb.c             |  965 ++++++++++++

Staging is not a shortcut around having things reviewed or broken out
logically. It's of course fine to merge the bulk of things in one go for
when a new architecture is going on, but logically disparate parts still
need to be broken out and sent to the proper places for review. It's
obvious you haven't done this for any of the non-arch bits and hiding
things under staging is not going to make this step any less necessary.

If you want your framebuffer driver reviewed, then split it out and
submit it to the linux-fbdev list for review. Once that's had a going
over and been Acked then of course it can be merged through whatever tree
you like, and there's even a good chance that you don't need to bother
with staging at all.

Using staging as a review circumvention measure however is just not going
to fly.
