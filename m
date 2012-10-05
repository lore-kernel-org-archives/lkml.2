Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2JEQqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:46:23 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:25847 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab2JEQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:46:22 -0400
Date: Fri, 5 Oct 2012 16:46:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 06/16] mm/slob: use min_t() to compare
 ARCH_SLAB_MINALIGN
In-Reply-To: <1349448930-23976-7-git-send-email-arnd@arndb.de>
Message-ID: <0000013a31d206df-8822ffd8-055d-4e9b-9b81-a8ec130ccc9d-000000@email.amazonses.com>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-7-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Arnd Bergmann wrote:

> Without this patch, building ARM collie_defconfig results in:
>
> mm/slob.c: In function '__kmalloc_node':
> mm/slob.c:431:152: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> mm/slob.c: In function 'kfree':
> mm/slob.c:484:153: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> mm/slob.c: In function 'ksize':
> mm/slob.c:503:153: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Acked-by: Christoph Lameter <cl@linux.com>
