Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1DYVeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:34:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932378Ab1DYVeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:34:18 -0400
Date: Mon, 25 Apr 2011 14:33:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 5/6] s390: use asm-generic/bitops/le.h
Message-Id: <20110425143319.f4c6e036.akpm@linux-foundation.org>
In-Reply-To: <1303638677-11211-6-git-send-email-akinobu.mita@gmail.com>
References: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
	<1303638677-11211-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011 18:51:16 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> The previous style change enables to use asm-generic/bitops/le.h
> on s390.

What kernel version is this patchset against?

>  }
>  #define find_next_bit_le find_next_bit_le
>  
> +#include <asm-generic/bitops/le.h>
> +
>  #include <asm-generic/bitops/ext2-atomic-test.h>
>  

Mainline arch/s390/include/asm/bitops.h doesn't have this inclusion.

Please recheck, redo and resend.
