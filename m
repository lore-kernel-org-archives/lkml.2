Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2LYS1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 13:27:45 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46452 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2LYS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 13:27:42 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH] kconfig:lxdialog: remove duplicate code
Date: Tue, 25 Dec 2012 19:21:51 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121217143751.GA16993@udknight> <201212171919.07368.yann.morin.1998@free.fr> <20121224044818.GA3863@udknight>
In-Reply-To: <20121224044818.GA3863@udknight>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212251921.52405.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Monday 24 December 2012 Wang YanQing wrote:
> On Mon, Dec 17, 2012 at 07:19:07PM +0100, Yann E. MORIN wrote:
> > Wang, All,
> > 
> > On Monday 17 December 2012 Wang YanQing wrote:
> > > dialog.h has two line the same below:
> > > extern char dialog_input_result[];
> > > This patch remove one of them.
> > > 
> > > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > 
> > Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Michal, All.
> 
> Hi Michal, could you consider pick up this obvious right
> patch,

This code-duplication-removal patch could qualify for post-rc1.

> and consider others' three patch I sented one week
> ago? I just don't want delay them to 2013, and they can get
> more test when they appear in next tree.
> https://patchwork.kernel.org/patch/1887361/
> https://patchwork.kernel.org/patch/1894341/
> https://patchwork.kernel.org/patch/1887441/

It's too late for those: the merge window is closed, and they did not even
went into Michal's tree, so they definitely do not qualify for post-rc1.
We'll have to wait until the next merge window for inclusion.

Michal probably got caught by this shorter-than-usual merge window, and
missed the deadline. :-/

Wang, I've queued them here, and will push them again to Michal, after
the holidays season is over.

Merry Chrtistmas, and a Happy New Year to all! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

