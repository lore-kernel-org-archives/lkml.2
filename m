Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0KIXgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:36:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38569 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0KIXga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:36:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=db2rN/gALfoxmLnmPNdYOEK+KjKUdP2S2cC5oSZgcse5FCmFMwfwh088cE5BBL1HaR
         BQ4mS+IvahF/4aVUsATBN/4AlDPTd/TBwvC3dNhVXaQrZQRfcJmaplQfjfpwXz9jyomW
         /vPesvNwIwtMTYjtya2R1SWTWL24B8Taw0qfo=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-5-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-5-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 08:36:29 +0900
Message-ID: <AANLkTinG7CY3VcWmWQBzNyUu0GKy-ZGKmaLWzRMA_poH@mail.gmail.com>
Subject: Re: [PATCH 4/6] memcg: simplify mem_cgroup_page_stat()
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> The cgroup given to mem_cgroup_page_stat() is no allowed to be
> NULL or the root cgroup.  So there is no need to complicate the code
> handling those cases.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

You already did what i want. :)
I should have commented after seeing all patches.

Thanks.
-- 
Kind regards,
Minchan Kim
