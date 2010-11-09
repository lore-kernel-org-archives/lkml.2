Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0KIRfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:35:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54078 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab0KIRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:35:51 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/tA2Xwcs1zzWAlh7GJAYKB
Date: Tue, 9 Nov 2010 09:35:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
Message-ID: <20101109173536.GE9264@atomide.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
 <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
 <201011091729.17679.arnd@arndb.de>
 <AANLkTikMjAh+LAFaWELyiJc+ou+N8v_7xhrwHRbBZZQF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikMjAh+LAFaWELyiJc+ou+N8v_7xhrwHRbBZZQF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Guzman Lugo, Fernando <fernando.lugo@ti.com> [101109 08:36]:
> 
> tidspbridge iommu change are working fine all the patches and few fixes after
> that are alredy sent. what breaks tidspbridge, is the unmerged
> dependencies in linux omap tree, specifically the iommu module patches
> and the SG patch.

Care to post a series of the missing patches listed above?

That way we can at least start merging those into linux-omap for
testing while waiting for the next merge window.

Tony
