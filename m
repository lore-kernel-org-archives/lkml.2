Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1ASBRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:17:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40041 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1ASBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gsycaqinIkGnrOXOTZMNR4Kt9A6SRWbdLx8UFv4qg7B1qbW/KFtIeet+dzMZUrWJ01
         VE7xVmtB99/3Qmm7H340icNms+xNAKnkLt7caRX5NmtKsVyBFU8oRJ2BaQUg696P3dFP
         j50G1OCIg04zWS3T6ZXwzyMbN3JxaP/iwqWp8=
MIME-Version: 1.0
In-Reply-To: <E1Pf9Zj-0002td-Ct@pomaz-ex.szeredi.hu>
References: <E1Pf9Zj-0002td-Ct@pomaz-ex.szeredi.hu>
Date: Wed, 19 Jan 2011 10:17:22 +0900
Message-ID: <AANLkTi=FWDf7DMA=huWzWa6a9cObKKcLFeoPvk3ynTfP@mail.gmail.com>
Subject: Re: [PATCH v4] mm: add replace_page_cache_page() function
From: Minchan Kim <minchan.kim@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 8:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Andrew,
>
> Can you please apply this to -mm, for 2.6.39?
>
> v4:
> - updated to latest -git
> - added acks
> - updated changelog
>
> Thanks,
> Miklos

6072d13c added freepage callback of filesystem.
So, all callers of __remove_from_page_cache handles it now.
Although NFS only need it and only FUSE use replace_page_cache_page,
do we have to handle it in replace_page_cache_page, too?

Or we pass mapping to __remove_from_page_cache and handle it in
__remove_from_page_cache?

-- 
Kind regards,
Minchan Kim
