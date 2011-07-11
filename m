Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1GKVsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:48:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56560 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1GKVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:48:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 11/11] watchdog: WatchDog Timer Driver Core - Remove llseek
Date: Mon, 11 Jul 2011 23:48:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1310392522-9949-1-git-send-email-wim@iguana.be> <1310392522-9949-11-git-send-email-wim@iguana.be> <20110711213535.GH5811@pengutronix.de>
In-Reply-To: <20110711213535.GH5811@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107112348.40423.arnd@arndb.de>
X-Provags-ID: V02:K0:42Kbb0vGm20FT2a3K7REz9NvqVs0US2qRO4MWdhKUyn
 vAtD8GX8mQM1lh9WR+WmoMnHHRigJGjJ1vzYx0qwi5Z8rRmOla
 9hGn3NPSKCQJ6cdvL3gctd5iLbvbTRaQiYlefM2dImDyLvxafq
 vYvDDcrIQe51MW9ivdBvVfQxoXjAzk6R9SazjGv/HRpuE6TAW1
 iG7C4N8bs0XlgkLn8TLwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 July 2011, Wolfram Sang wrote:
> On Mon, Jul 11, 2011 at 04:24:39PM +0200, Wim Van Sebroeck wrote:
> > No need to set no_llseek any more since it's the default now.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> I'd think we can squash this into patch 1? Arnd?

Yes, certainly if you like.

	Arnd
