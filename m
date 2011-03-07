Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1CGPjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:39:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48819 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1CGPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A9nNicuNvyvZNG1VymU3DpzzlIoPXxxvsryYNzzxrRclOEfpRDXj2E9/oT+TCPll3w
         FycznkqBBWoYlXyYqEawmeK8GIikk5OK+jVrKjqHjkgwY/7BpamZ8cDekA4L9uwKu5/R
         Q+2dYc2Ofr18FXotKgydhP7JaFlgb5PAZJbO8=
MIME-Version: 1.0
In-Reply-To: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
References: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
Date: Tue, 8 Mar 2011 00:39:34 +0900
Message-ID: <AANLkTimsm7KmgdfUozrJ8=SFfBtikZJuCdiyrNtgVphk@mail.gmail.com>
Subject: Re: [PATCH] mm: remove inline from scan_swap_map
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 3:49 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> scan_swap_map is a large function (224 lines), with several loops and a
> complex control flow involving several gotos.
>
> Given all that, it is a bit silly that is is marked as inline. The
> compiler agrees with me: on a x86-64 compile, it did not inline the
> function.
>
> Remove the "inline" and let the compiler decide instead.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
