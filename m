Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2HFSMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab2HFSMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:12:53 -0400
Message-ID: <1344271304.11053.17.camel@dcbw.foobar.com>
Subject: Re: [PATCH]: Mac80211 driver and I checked the patch
From: Dan Williams <dcbw@redhat.com>
To: Christopher Sacchi <chris.sacchi@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 06 Aug 2012 11:41:44 -0500
In-Reply-To: <CAGh4K3Lym9yETNbMutfjNuANrgwtvfrGes6emr3Mvhx47D3B2g@mail.gmail.com>
References: <CAGh4K3Lym9yETNbMutfjNuANrgwtvfrGes6emr3Mvhx47D3B2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 11:49 +0000, Christopher Sacchi wrote:
> The source file needed a change  that was told in the description to
> know that the #include needed to be fixed, and the function changed
> another value to 0 (yes) in the description (that said FIXME.) The
> patch fixes a typo-like error and has been checked with checkpatch.pl
> in the scripts directory.
> Here's the patch:

It's great that you're sending patches, but it also helps the developers
when the patches are correctly formatted.  See:

http://linux.yyz.us/patch-format.html

Here's a good example:

http://lkml.org/lkml/2012/8/2/286

1) the subject line starts with [PATCH] *and* the module being patches,
then quickly describes the patch
2) There's a Signed-off-by comes *before* the patch data
3) The full path to the files being patched is in the patch header (ie,
not just "main.c" but foo/bar/baz/main.c)

Cheers,
Dan

> --- main.c	2012-07-21 20:58:29.000000000 +0000
> +++ mainnew.c	2012-08-05 20:00:37.000000000 +0000
> @@ -32,7 +32,7 @@
>  #include "led.h"
>  #include "cfg.h"
>  #include "debugfs.h"
> -
> +#include "net/rfkill/rfkill.h"
>  static struct lock_class_key ieee80211_rx_skb_queue_class;
> 
>  void ieee80211_configure_filter(struct ieee80211_local *local)
> @@ -183,6 +183,7 @@ int ieee80211_hw_config(struct ieee80211
>  		 *
>  		 */
>  		/* WARN_ON(ret); */
> +		WARN_ON(1)
>  	}
> 
>  	return ret;
> Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
> --
> 


