Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1CERVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:21:41 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:51216 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1CERVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kdtgzv6ay3uDowOvpe4mtVBVi95qs+tVs7fURD8oX8dqmmJnc7msJtWuo/XCkXoMXu
         v/DA1v3Nebmne0K6mXCqmHgCP24ZSkXA7JKh/Y/ffNXBRQZvxy+HXEvA3JeUITBKI2nU
         mLlrWh/YqrHylcceB3CvkYIj/Oz+POCPMUtaE=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-24-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-24-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:21:39 +0200
X-Google-Sender-Auth: ifzldHrlLX-wsU36IhJLWr6nEKs
Message-ID: <AANLkTinqaotJoaGZh=5iO639JEX7-b03U0LUjrKBTzBo@mail.gmail.com>
Subject: Re: [PATCHv2 23/24] sys_swapoff: change order to match sys_swapon
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
> The block in sys_swapon which does the final adjustments to the
> swap_info_struct and to swap_list is the same as the block which
> re-inserts it again at sys_swapoff on failure of try_to_unuse(), except
> for the order of the operations within the lock. Since the order should
> not matter, arbitrarily change sys_swapoff to match sys_swapon, in
> preparation to making both share the same code.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
