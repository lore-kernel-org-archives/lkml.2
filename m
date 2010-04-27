Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0D0JDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:03:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0D0JC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:02:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the bkl-ioctl tree with my fixes tree
Date: Tue, 27 Apr 2010 11:02:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "=?iso-8859-15?q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20100427150629.cb526876.sfr@canb.auug.org.au>
In-Reply-To: <20100427150629.cb526876.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004271102.35904.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18At6tbF4CbNShqxOBv6hsIDKJVmmRr55NsveS
 0pDofXZgb0tuO15pmsQMk0l21K5yZLtdZZqJMTJAqQVlqf20bn
 TifXUQOwqpGZaBGdd7NVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Stephen Rothwell wrote:
> Today's linux-next merge of the bkl-ioctl tree got a aconflics in
> drivers/block/pktcdvd.c between commit
> 30d32c9015af1fa56795c5ba8d7d6635d6bef8bf ("pktcdvd: improve BKL and
> compat_ioctl.c usage") from my fixes tree and commit
> 1dd97d3d546aa14db7efa5366b21d1336b91379e ("Rename 'struct
> file_operations' 'ioctl' fn pointer to 'bkl_ioctl'") from the bkl-ioctl
> tree.
> 
> I used the version from my fixes tree for today.
> 
> Arnd, are you going to submit this change to Linus sometime soon, or
> should I drop it?

It's not clear yet how we do it. Ideally "pktcdvd: improve BKL and
compat_ioctl.c usage" should find its way into -rc1 in some way, but
we need to reshuffle the BKL removal trees to make that go in nicely.

Where is your fixes tree? Maybe Frederic can take all BKL related
patches from that into one of his trees.

	Arnd
