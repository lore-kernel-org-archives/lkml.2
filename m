Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0JDI0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:26:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0JDI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:26:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT is defined
Date: Mon, 4 Oct 2010 10:26:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com> <201009251755.57690.arnd@arndb.de> <20100927123252.8e1826e8.akpm@linux-foundation.org>
In-Reply-To: <20100927123252.8e1826e8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041026.42385.arnd@arndb.de>
X-Provags-ID: V02:K0:4lVv0l3VLkdHhWSHS8wPVwTQls0JW+q5YcxcGbSet0I
 d4TLalbKAGggMZSTslUY3YQsJNaVqlgQevQTfgUVsfO/ETzeVI
 MIdWIPeeuxBmqWxLGv6bcCAgnnfcg5OtwZh4lopc4Nmf+jDgXS
 8iQ5tVDGfxUTJJHk/ueU1OLGvNnTjAzhfm4M5oodSPY8C9Du4p
 Sta4WcGfbmSwC+inyu1Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010 21:32:52 Andrew Morton wrote:
> > My initial reaction was to put these into my bkl/vfs tree, but then I noticed
> > that they are against a 2.6.36 bug. Who's taking care of getting them upstream?
> > 
> > - Ian (maintainer)
> > - Arnd (who wrote the broken patch to start with)
> > - Frederic (who pushed the broken patch to Linus)
> > - Andrew (took them into -mm)
> > 
> > I don't care either way, just trying to make sure it gets there and we don't
> > all submit the same patch simultaneously.
> 
> The usual deal: if it turns up in linux-next then I drop it.  If it
> doesn't then I'll merge it into 2.6.37.

I ended up putting them into my bkl/vfs tree after all now.

	Arnd
