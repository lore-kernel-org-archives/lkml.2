Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1CBVyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:54:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab1CBVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:54:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/7] Final BKL removal, take 2
Date: Wed, 2 Mar 2011 22:54:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>, linux-fsdevel@vger.kernel.org,
        linux-x25@vger.kernel.org, Max Vozeler <max@vozeler.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        netdev@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        Nick Piggin <npiggin@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de> <20110302140428.GA630@suse.de> <4D6EA965.9050709@redhat.com>
In-Reply-To: <4D6EA965.9050709@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103022254.10078.arnd@arndb.de>
X-Provags-ID: V02:K0:/32bqq42jvmEghowr5HWOILsnNIJNmCtoK3W5PXpjn4
 18HocFqynt9d8ydYzZnNz81o9JPv7rtOz8MBAWCcuHm5KaweZh
 mYBBUepzV4u049BFNbymXOwfAXNOX1zqmLlaaHqjR7jrLmzE7g
 WsPfK7uHRS1jOtP4sMR27VA8V/TGVjZ33TMbc1BYkjmlJEOhRM
 +MXayjlKrI55KFovqaEGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011 21:32:37 Mauro Carvalho Chehab wrote:
> >>
> >> It is probably better to queue the staging/cx25821 patch via my tree, as this is one
> >> of those staging files that it is handled via media tree. So, if it is ok
> >> for you both, I'll get patch 2/7.
> > 
> > Yes, you are right, please take it through your tree.
> 
> Patch applied on my tree, thanks!

I've pushed out everything to my git tree, except for the two staging
patches that go through the other trees.

Once everything is in -next, I'll add the last patch to remove the
infrastructure.

Thanks for the feedback!

	Arnd
