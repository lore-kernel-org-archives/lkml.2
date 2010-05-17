Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0EQL6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:58:19 -0400
Received: from mail-iw0-f179.google.com ([209.85.214.179]:34726 "EHLO
	mail-iw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0EQL6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:58:16 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 07:58:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BjAHa8mgcrE74lyanGHB0tkZEYjYQMFft8y5HvAsrnjY7z12r7ruhN+wjgsjQzUPZn
         Scq/NboBWv1dqxkHGn1WHHaC8NEW1nKgeVp7v8awk10WbeiEab6L5kjXDxwBDXeeHD1s
         kdq5FHRjCkgQifGykM67C791g7jeHLyZR0e80=
MIME-Version: 1.0
In-Reply-To: <1274074364-8838-2-git-send-email-ngupta@vflare.org>
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
	 <1274074364-8838-2-git-send-email-ngupta@vflare.org>
Date: Mon, 17 May 2010 20:50:03 +0900
Message-ID: <AANLkTikvu85a6Ckl-iJaF_iHlCCsK9tMRYoT21EeZ_CV@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 2:32 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Added SWP_BLKDEV flag to distinguish block and regular file backed
> swap devices. We could also check if a swap is entire block device,
> rather than a file, by:
> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
> but, I think, simply checking this flag is more convenient.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

We can enhance swap_show by the flag as further patch.

-- 
Kind regards,
Minchan Kim
