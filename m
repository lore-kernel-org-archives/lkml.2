Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1IWFwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 01:52:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1IWFwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 01:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <201109221815.08891.hartleys@visionengravers.com>
References: <201109221815.08891.hartleys@visionengravers.com>
Date: Fri, 23 Sep 2011 11:22:08 +0530
Message-ID: <CAKTCnznRZbcsnHyV=+-DDd2fkAZ+kqyqrCoos+4ZmBxGBPNQYg@mail.gmail.com>
Subject: Re: [PATCH] mm/page_cgroup.c: quiet sparse noise
From: Balbir Singh <bsingharora@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        containers@lists.linux-foundation.org, paul@paulmenage.org,
        lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 6:45 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Quite the sparse noise:
>
> warning: symbol 'swap_cgroup_ctrl' was not declared. Should it be static?
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> ---
>
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 6bdc67d..eead840 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -357,7 +357,7 @@ struct swap_cgroup_ctrl {
>        spinlock_t      lock;
>  };
>
> -struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
> +static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];

Seems reasonable

Acked-by: Balbir Singh <bsingharora@gmail.com>
