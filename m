Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0KIRwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:52:24 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:60212 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab0KIRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <20101109173536.GE9264@atomide.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
	<AANLkTikMjAh+LAFaWELyiJc+ou+N8v_7xhrwHRbBZZQF@mail.gmail.com>
	<20101109173536.GE9264@atomide.com>
Date: Tue, 9 Nov 2010 11:52:17 -0600
Message-ID: <AANLkTinLORQ7Hyn7nqkNZhRbP8iTGRfAXibgY2VeZTPq@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 11:35 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Guzman Lugo, Fernando <fernando.lugo@ti.com> [101109 08:36]:
>>
>> tidspbridge iommu change are working fine all the patches and few fixes after
>> that are alredy sent. what breaks tidspbridge, is the unmerged
>> dependencies in linux omap tree, specifically the iommu module patches
>> and the SG patch.
>
> Care to post a series of the missing patches listed above?

Here are the missing patches:

Fernando Guzman Lugo (4):
  iovmm: no gap checking for fixed address
  iovmm: add superpages support to fixed da address
  iovmm: replace __iounmap with omap_iounmap
  iommu: create new api to set valid da range

and
  scatterlist: define SG chain for arm architecture


Regards,
Fernando.



>
> That way we can at least start merging those into linux-omap for
> testing while waiting for the next merge window.
>
> Tony
>
