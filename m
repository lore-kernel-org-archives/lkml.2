Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1CERKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:10:51 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1CERKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=urJdsHMeFO2Iy/pD5BP/JLCWyUWg3A8qLculUveGgozj9M9rBBuKB+hC1sykYBIx7N
         34iSZaFZrkOAvBse8lZ8YDrakjWoNzjk1StLZOs8lgCbHl3cWlNJyzULfuKRF34Rggo3
         QcUMhHEWyQ/s2yihgJ7jxflJM6bbyqYyyUlyc=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-7-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-7-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:10:49 +0200
X-Google-Sender-Auth: VgYHtq82W9JCzmvQ1AJLmTAblqY
Message-ID: <AANLkTikdXLUaE2dJgEzBFpc_e6Pgu6rwML+dowdJ22w3@mail.gmail.com>
Subject: Re: [PATCHv2 06/24] sys_swapon: simplify error flow in alloc_swap_info
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
> Since there is no cleanup to do, there is no reason to jump to a label.
> Return directly instead.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
