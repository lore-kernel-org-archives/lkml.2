Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0DFLEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:04:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45177 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0DFLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=nzjQAdGmZhNldXHGA8N2QBQIVcp7vasvSytaNix6QZcuXsAYmUA6t2cT96r2SWoAQK
         B+O5UffaPcfbAatsFqkfsIDAIYlkeG3qtLIKvwHSuHbt5FefHB/ZiKWdKEpAPssi/QlG
         06eP9Zv8IDJCuhj2LCoZc5GfNCuSa5CFxhqSI=
MIME-Version: 1.0
In-Reply-To: <20100406104539.GC21229@bicker>
References: <20100406104539.GC21229@bicker>
Date: Tue, 6 Apr 2010 20:04:03 +0900
Message-ID: <v2p28c262361004060404u63146873x725d8927c47a3329@mail.gmail.com>
Subject: Re: [patch] proc: copy_to_user() returns unsigned
From: Minchan Kim <minchan.kim@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Matt Mackall <mpm@selenic.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got confused when I see the title of patch.
That's because I understood copy_to_user returns unsigned.
Please, change title to describe your patch.

[PATCH] proc : fix wrong usage of copy_to_user's return value.

Maybe you could name it well than me who is a not native English.

On Tue, Apr 6, 2010 at 7:45 PM, Dan Carpenter <error27@gmail.com> wrote:
> copy_to_user() returns the number of bytes left to be copied.
>
> This was a typo from: d82ef020cf31504c816803b1def94eb5ff173363
> "proc: pagemap: Hold mmap_sem during page walk".
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
