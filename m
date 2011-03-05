Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1CERIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:08:21 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:57675 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1CERIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U0eclq7ArWeY2EtxdULhCBxi0m3ln4O06vNNMAaz+UONIx2kQUzGU50QPJr88KpM7v
         tCr1YJa6P4IvGHTOJF/e/lQructuxJTAQDkUqV7jHIskrqsTXzB9kZLs9Oy4QrE4Opto
         F6sMOYghQQ5Nz+tL/7fdBGNsNKhPny9py7zuo=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-6-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-6-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:08:19 +0200
X-Google-Sender-Auth: Xc9GYvCZpzthLO8iiVhvZhB2QIM
Message-ID: <AANLkTik29hmXwgnJjhehESNWiNwnTpQFOiJo-NJEoEL1@mail.gmail.com>
Subject: Re: [PATCHv2 05/24] sys_swapon: simplify error return from swap_info allocation
From: Pekka Enberg <penberg@kernel.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 6:42 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> At this point in sys_swapon, there is nothing to free. Return directly
> instead of jumping to the cleanup block at the end of the function.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
