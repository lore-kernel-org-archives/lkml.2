Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1ALXDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:03:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44663 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1ALXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GgtQGmo1lwfuVnIzKbE9PSTpRSnMPYKjEM+Rvds4s3Amm/eFBQNIsXoz4NcB/LSxTv
         hTErsOHlTj8AXC6jtbApMnzjvbyZb2IPwxDhO9pl7QAuyCaQe2gj0Ubo75F4FFJhXRbA
         ROZ6kDGKsOgsSmeOISCD20mpIoAgpeJJvtNsg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
Date: Thu, 13 Jan 2011 08:03:51 +0900
Message-ID: <AANLkTinqVZhUWqxJEOcC-j5ZPuU7ZVRnqSo_FoQ1DCs6@mail.gmail.com>
Subject: Re: [PATCH] mm: Remove two memset calls in mm/memcontrol.c by using
 the zalloc variants of alloc functions
From: Minchan Kim <minchan.kim@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 5:39 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> We can avoid two calls to memset() in mm/memcontrol.c by using
> kzalloc_node(), kzalloc & vzalloc().
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
