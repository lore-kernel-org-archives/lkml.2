Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0JOLOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:14:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50796 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0JOLOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:14:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 00/22] Introduce little endian bitops
Date: Fri, 15 Oct 2010 13:14:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151314.57428.arnd@arndb.de>
X-Provags-ID: V02:K0:8wIQHC6PWgIgh7kqD1N9bb79lYWpnkS73aG8NEGAwTN
 Qt/wjX2irhedTahCPoxtdh+E8KjavJIBmY9extXJN7jYk4OSNy
 M3Sqm87a9/7LVxhn73pPn+iCBKNDMPsZDdhMGQaOSyEzpEOgBr
 5EFzAz/PLS2ohvatbyIjEAq4UxqZSs0xN4W7NFapzQsr0JuGvC
 zmA7Y9jIhLaH+JpOq6QyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010, Akinobu Mita wrote:
> 
> This patch series introduces little endian bit operations in asm/bitops.h
> for all architectures and converts ext2 non-atomic and minix bit operation
> to them. it enables to remove ext2 non-atomic and minix bit operations
> from asm/bitops.h. The reason they should be removed from asm/bitops.h
> is as follows:
> 
> For ext2 non-atomic bit operations, they are used for little endian byte order
> bitmap access by some filesystems and modules. But using ext2_*() functions on
> a module other than ext2 filesystem makes someone feel strange.
> 
> For minix bit operations, they are only used by minix filesystem and useless
> by other modules. Because byte order of inode and block bitmap is defferent
> on each architectures.

Very nice work! I already replied on two issues that I think could be improved,
everything else looks good.

	Arnd
