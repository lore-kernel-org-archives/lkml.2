Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KJBEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:04:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64652 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0KJBEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RvBIp/uRmG5fQX72vd9UykAsa4ojgK1LOmmgY2CPt+xUfzbUbEwmLaGFSxpp14E1H+
         8AiGIQDO03Kxr3YXEq9p0V10+CZyRr6mHHcd3+L+NP5pzTPHpKQxkIdwEvmKLkhv0b52
         XPcGR23fpqriCJCV8nPgjS9WNfAnlm0+RtK+M=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-7-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-7-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 10:04:29 +0900
Message-ID: <AANLkTi=fZq_+DiD+E__KhgTQz86eTrALGE9M7twX3hgB@mail.gmail.com>
Subject: Re: [PATCH 6/6] memcg: make mem_cgroup_page_stat() return value unsigned
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> mem_cgroup_page_stat() used to return a negative page count
> value to indicate value.
>
> mem_cgroup_page_stat() has changed so it never returns
> error so convert the return value to the traditional page
> count type (unsigned long).
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

It seems to be late review. Just 1 day.
I don't know why Andrew merge it in a hurry without any review.
Anyway, I add my Reviewed-by in this series since my eyes can't find
any big bug.

Thanks.
-- 
Kind regards,
Minchan Kim
