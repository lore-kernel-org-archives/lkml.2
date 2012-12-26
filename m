Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2LZAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 19:09:58 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:57221 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2LZAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 19:09:54 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig:lxdialog: remove duplicate code
Date: Wed, 26 Dec 2012 01:09:48 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
References: <20121217143751.GA16993@udknight> <20121224044818.GA3863@udknight> <201212251921.52405.yann.morin.1998@free.fr>
In-Reply-To: <201212251921.52405.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212260109.49002.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Tuesday 25 December 2012 Yann E. MORIN wrote:
> On Monday 24 December 2012 Wang YanQing wrote:
[--SNIP--]
> > and consider others' three patch I sented one week
> > ago? I just don't want delay them to 2013, and they can get
> > more test when they appear in next tree.
> > https://patchwork.kernel.org/patch/1887361/
> > https://patchwork.kernel.org/patch/1894341/
> > https://patchwork.kernel.org/patch/1887441/
[--SNIP--]
> Wang, I've queued them here, and will push them again to Michal, after
> the holidays season is over.

I've started gathering kconfig-related patches suitable for post-3.8 there:
    git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

They are browseable there:
    https://www.gitorious.org/linux-kconfig/linux-kconfig/commits/yem-kconfig-for-next

I'll send a proper pull-request to Michal in a litle while.

Note: the autoritative tree for kconfig is Michal's. I'm only doing this
gathering of patches in an attempt to not forget any, and to make Michal's
life easier, if he finds it usefull to pull from there.

Branches in that tree are based off Michal's branches, and so will be
rebased accordingly.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

