Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2BPP3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:29:36 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:33627 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab2BPP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:29:33 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs/check-integrity.c: included disk-io.h twice
Date: Thu, 16 Feb 2012 16:28:35 +0100
User-Agent: KMail/1.9.10
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329400529-31793-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329400529-31793-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202161628.35806.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329406173;4458ed2d;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ignore this one, it's already in linux-next.

Danny

On Donnerstag, 16. Februar 2012, Danny Kukawka wrote:
> fs/btrfs/check-integrity.c included disk-io.h twice, remove the
> duplicate.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  fs/btrfs/check-integrity.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index b669a7d..064b29b 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -89,7 +89,6 @@
>  #include "disk-io.h"
>  #include "transaction.h"
>  #include "extent_io.h"
> -#include "disk-io.h"
>  #include "volumes.h"
>  #include "print-tree.h"
>  #include "locking.h"


