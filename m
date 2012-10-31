Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab2JaHZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:25:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40845 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab2JaHZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:25:21 -0400
Date: Wed, 31 Oct 2012 09:25:17 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH 06/16] mm/slob: use min_t() to compare
 ARCH_SLAB_MINALIGN
In-Reply-To: <0000013a31d206df-8822ffd8-055d-4e9b-9b81-a8ec130ccc9d-000000@email.amazonses.com>
Message-ID: <alpine.LFD.2.02.1210310925110.2281@tux.localdomain>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-7-git-send-email-arnd@arndb.de> <0000013a31d206df-8822ffd8-055d-4e9b-9b81-a8ec130ccc9d-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Christoph Lameter wrote:

> On Fri, 5 Oct 2012, Arnd Bergmann wrote:
> 
> > Without this patch, building ARM collie_defconfig results in:
> >
> > mm/slob.c: In function '__kmalloc_node':
> > mm/slob.c:431:152: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > mm/slob.c: In function 'kfree':
> > mm/slob.c:484:153: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > mm/slob.c: In function 'ksize':
> > mm/slob.c:503:153: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Applied, thanks!
