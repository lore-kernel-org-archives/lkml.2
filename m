Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab1BHWsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:48:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39300 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1BHWsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eqmm3rYjUsus8IVk56FcC3RxeqxrWjGjQc9CURQzysTk6WF3o5FrGc0GKYiqt+0ROk
         xyXGDj4cqsF8rBVn8SW4srPh3bDdhcu3npRr13U+7XgfTLpw+WY+nNbEMkLhue/MN2ZX
         LjLS4PR2po8/5+CKeo+sXv8i5h5eMDdl2wgE8=
MIME-Version: 1.0
In-Reply-To: <20110207032608.GA27453@ca-server1.us.oracle.com>
References: <20110207032608.GA27453@ca-server1.us.oracle.com>
Date: Wed, 9 Feb 2011 07:48:22 +0900
Message-ID: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
From: Minchan Kim <minchan.kim@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: gregkh@suse.de, chris.mason@oracle.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, matthew@wil.cx,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        jeremy@goop.org, kurt.hackel@oracle.com, npiggin@kernel.dk,
        riel@redhat.com, konrad.wilk@oracle.com, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 12:26 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
>
> Zcache provides host services (memory allocation) for tmem,
> a "shim" to interface cleancache and frontswap to tmem, and
> two different page-addressable memory implemenations using
> lzo1x compression.  The first, "compression buddies" ("zbud")
> compresses pairs of pages and supplies a shrinker interface
> that allows entire pages to be reclaimed.  The second is
> a shim to xvMalloc which is more space-efficient but
> less receptive to page reclamation.  The first is used
> for ephemeral pools and the second for persistent pools.
> All ephemeral pools share the same memory, that is, even
> pages from different pools can share the same page.
>
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Hi Dan,
First of all, thanks for endless effort.

I didn't look at code entirely but it seems this series includes frontswap.
Finally frontswap is to replace zram?

If it is right, how about approaching one by one for easy review and merging?
I mean firstly we replace zram into frontswap and tmem and then zcache.
Regardless of my suggestion, I will look at the this series in my spare time.

-- 
Kind regards,
Minchan Kim
