Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab0JUPFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:05:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JUPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:05:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 01/22] bitops: merge little and big endian definisions in asm-generic/bitops/le.h
Date: Thu, 21 Oct 2010 17:06:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com> <1287672077-5797-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1287672077-5797-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211706.15042.arnd@arndb.de>
X-Provags-ID: V02:K0:WFb1/jdmlvXFFmJy9xHhRySEUhhq6C3jy5z2WIrtknS
 b97TlnF6dqQDBKanMFDGHv5JauRlaR/hHxt/GCmABs+MhZ4w4U
 bh84g/SNUSF4T6KVR5kuIX0EHqazFBT1LGzwPFGTnvhNGZf5hZ
 BU6rtQjKRjy5RKgXpU2pRqYHUjnd4qY38oNvhp02P4td50m32n
 T5f9Qe6epKTqtsOqdT+RA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Akinobu Mita wrote:
> In order to make the forthcoming changes smaller, this merges
> macro definisions in asm-generic/bitops/le.h for big-endian and
> little-endian as much as possible.
> 
> This also removes unused BITOP_WORD macro.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
