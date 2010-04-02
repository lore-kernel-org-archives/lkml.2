Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab0DBFQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:16:03 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:57007 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0DBFP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RkOyckHW384ZVus/JvgUIJg9xFjOAj39fFqzqUww3998aQisiAbirtZm3TerXv3Eoq
         5BHtkiyiAAfMZkRydJ0aARcLf1eFDwU2pfu4+ff1WqkBy61Oo5pRptnieE8HYgEuq7kl
         MVmtVOrhg+09u6erL+WRPwg556daSFhVmiIQg=
MIME-Version: 1.0
In-Reply-To: <20100402140406.d3d7f18e.kamezawa.hiroyu@jp.fujitsu.com>
References: <i2i5f4a33681003312105m4cd42e9ayfe35cc0988c401b6@mail.gmail.com>
	 <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
	 <20100402140406.d3d7f18e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 2 Apr 2010 14:15:56 +0900
Message-ID: <z2x28c262361004012215h2b2ea3dbu5260724f97f55b95@mail.gmail.com>
Subject: Re: [Question] race condition in mm/page_alloc.c regarding page->lru?
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: TAO HU <tghk48@motorola.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chang Qing-A21550 <Qing.Chang@motorola.com>,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 2:04 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 2 Apr 2010 11:51:33 +0800
> TAO HU <tghk48@motorola.com> wrote:
>
>> 2 patches related to page_alloc.c were applied.
>> Does anyone see a connection between the 2 patches and the panic?
>> NOTE: the full patches are attached.
>>
>
> I don't think there are relationship between patches and your panic.
>
> BTW, there is other case about the backlog rather than race in alloc_pages()
> itself. If someone list_del(&page->lru) and the page is already freed,
> you'll see the same backlog later.
> Then, I doubt use-after-free case rather than complicated races.

It does make sense.
Please, grep "page handling" by out-of-mainline code.
If you found out, Please, post it.

-- 
Kind regards,
Minchan Kim
