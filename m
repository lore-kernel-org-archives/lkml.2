Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2DOQEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:04:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40178 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2DOQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:04:20 -0400
Date: Sun, 15 Apr 2012 19:04:15 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Xi Wang <xi.wang@gmail.com>
cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Jens Axboe <axboe@kernel.dk>, Dan Carpenter <dan.carpenter@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] CodingStyle: add kmalloc_array() to memory allocators
In-Reply-To: <1334396894-27176-1-git-send-email-xi.wang@gmail.com>
Message-ID: <alpine.LFD.2.02.1204151903590.1706@tux.localdomain>
References: <1334396894-27176-1-git-send-email-xi.wang@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2012, Xi Wang wrote:
> Add the new kmalloc_array() to the list of general-purpose memory
> allocators in chapter 14.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: Jesper Juhl <jj@chaosbits.net>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> ---

Acked-by: Pekka Enberg <penberg@kernel.org>
