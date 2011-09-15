Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab1IOMEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:04:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56267 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IOMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:04:08 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Pawel Sikora <pluto@agmk.net>, Lin Ming <mlin@ss.pku.edu.cn>,
        Andrew Morton <akpm@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Alan Piszcz <ap@solarrain.com>
In-Reply-To: <alpine.DEB.2.02.1109150708540.23647@p34.internal.lan>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <20110913165344.1d800582.akpm@google.com>
	 <CAF1ivSbCb-eS=npyHO+iWuAXfKPjnCD+LZDWQQ9SbTxGg3nq7Q@mail.gmail.com>
	 <3669551.Uo4Qe4YO2W@pawels>
	 <alpine.DEB.2.02.1109150708540.23647@p34.internal.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 14:04:15 +0200
Message-ID: <1316088255.2893.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 07:11 -0400, Justin Piszcz a écrit :
> 

> Before patches:
> Aug 30 05:00:48 p34 kernel: [122150.720173]  [<ffffffff8103798a>] warn_slowpath_common+0x7a/0xb0
> Sep 10 20:59:39 p34 kernel: [531189.671424]  [<ffffffff810379ba>] warn_slowpath_common+0x7a/0xb0
> 
> After patches:
> (no errors)
> 
> Patches you need (against 3.1-rc4):
> 
> (for the igb problem/memory allocation issue)
> 0001-Fix-pointer-dereference-before-call-to-pcie_bus_conf.patch
> 0002-PCI-Remove-MRRS-modification-from-MPS-setting-code.patch
> 
> (for the RCU/memory errors)
> 0003-filemap.patch
> 
> I've attached them to this e-mail, they seem to have fixed all of my 
> problems so far.
> 

Or just pull latest Linus tree. No need to repost those patches over and
over ;)

from your local copy, do :

git pull https://github.com/torvalds/linux.git


