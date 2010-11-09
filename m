Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0KIV0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:26:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34478 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab0KIV0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q2Hpy0BmrSmZMZOTsmH/LoYc0He1KDS6bojcxtXNuWZe0kqMzLD4ZkpdWhR7ZSCznG
         BVe7/yRktvX8TXkE71v/CATrdc0Hdp5YS+J26cl8gfgIua+7iWmwbwuQPQ9ZfhjINBqj
         deJBJRN4asYtavy4rtwvnANU/scV4uH3VvyhM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLORQ7Hyn7nqkNZhRbP8iTGRfAXibgY2VeZTPq@mail.gmail.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
	<AANLkTikMjAh+LAFaWELyiJc+ou+N8v_7xhrwHRbBZZQF@mail.gmail.com>
	<20101109173536.GE9264@atomide.com>
	<AANLkTinLORQ7Hyn7nqkNZhRbP8iTGRfAXibgY2VeZTPq@mail.gmail.com>
Date: Tue, 9 Nov 2010 23:26:04 +0200
Message-ID: <AANLkTimmd=jKk_x4DNao_NG9dEiQtQvOQ=TePn-Dgc_b@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 7:52 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
> On Tue, Nov 9, 2010 at 11:35 AM, Tony Lindgren <tony@atomide.com> wrote:
>> * Guzman Lugo, Fernando <fernando.lugo@ti.com> [101109 08:36]:
>>>
>>> tidspbridge iommu change are working fine all the patches and few fixes after
>>> that are alredy sent. what breaks tidspbridge, is the unmerged
>>> dependencies in linux omap tree, specifically the iommu module patches
>>> and the SG patch.
>>
>> Care to post a series of the missing patches listed above?
>
> Here are the missing patches:
>
> Fernando Guzman Lugo (4):
>  iovmm: no gap checking for fixed address
>  iovmm: add superpages support to fixed da address
>  iovmm: replace __iounmap with omap_iounmap
>  iommu: create new api to set valid da range
>
> and
>  scatterlist: define SG chain for arm architecture

Those are not the only patches needed, you would also need:
 omap: iommu: make iva2 iommu selectable
 staging: tidspbridge: enable iva2 iommu

And the one that actually uses the new API for the da range which
hasn't even been submitted to the mailing list.

Personally, I haven't seen the new iommu code working correctly.

-- 
Felipe Contreras
