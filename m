Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0KAT6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:58:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51639 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0KAT6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W+I5LGFgbCqAR5anpFy1bAfudRJf2yT6BkiCQB0O91HSDzHdZf2rYQMvT3lYZd5Ub6
         Mvl0JHAhp7UzUNLov5rXCIplrAZjTOsxTDqjKTE0zHSgWNhfLxDXrTNYLFwJBixwTaZW
         +tTAUfcQ/LKcENAUlxgEDAM9vvnbFOGYnpmSc=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
Date: Tue, 2 Nov 2010 04:58:43 +0900
Message-ID: <AANLkTinLfkmEczRs_7aw8GFBEX_1Dzoh=R024_R1KY85@mail.gmail.com>
Subject: Re: [PATCH] cgroup: prefer [kv]zalloc over [kv]malloc+memset in
 memory controller code.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Jesper Juhl <jj@chaosbits.net>:
> Hi (please CC me on replies),
>
>
> Apologies to those who receive this multiple times. I screwed up the To:
> field in my original mail :-(
>
>
> In mem_cgroup_alloc() we currently do either kmalloc() or vmalloc() then
> followed by memset() to zero the memory. This can be more efficiently
> achieved by using kzalloc() and vzalloc().
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
