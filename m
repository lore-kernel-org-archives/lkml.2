Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0HKHbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:31:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:55446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0HKHbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:31:17 -0400
Date: Wed, 11 Aug 2010 09:31:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix a typo on comments in mm/percpu.c
In-Reply-To: <1281493450-2685-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.LNX.2.00.1008110930570.2702@pobox.suse.cz>
References: <1281493450-2685-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010, Namhyung Kim wrote:

> 'eqaul' should be 'equal'.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  mm/percpu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 5e78131..3ec4dc9 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -31,7 +31,7 @@
>   * as small as 4 bytes.  The allocator organizes chunks into lists
>   * according to free size and tries to allocate from the fullest one.
>   * Each chunk keeps the maximum contiguous area size hint which is
> - * guaranteed to be eqaul to or larger than the maximum contiguous
> + * guaranteed to be equal to or larger than the maximum contiguous
>   * area in the chunk.  This helps the allocator not to iterate the
>   * chunk maps unnecessarily.
>   *

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
