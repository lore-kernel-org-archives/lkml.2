Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0JOLFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:05:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0JOLFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:05:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 10/22] asm-generic: use little endian bitops
Date: Fri, 15 Oct 2010 13:06:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <1287135981-17604-11-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1287135981-17604-11-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151306.14366.arnd@arndb.de>
X-Provags-ID: V02:K0:z4gt3ysboZcB28yups3qJCm3utBjQ6K6daffoHovzt+
 dCuT3lVFMVLrdVS1Wf5990rXIWaR9BkPpWqdPHdAiiuOGj38PR
 +XXlAKKp8VRTfYLY/sB4a+x/DfTL39DbKuiOA0+H5i4j6gzK+L
 QoScDsf5eNWyJbqGRmuAfhvtVvEudjg1f0Bv5xUgRQM7rucYac
 CF2r6uZkUXOr2zISDFLaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010, Akinobu Mita wrote:
> As a preparation for removing ext2 non-atomic bit operations from
> asm/bitops.h. This converts ext2 non-atomic bit operations to
> little endian bit operations.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
