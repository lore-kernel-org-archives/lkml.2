Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab1CDIny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:43:54 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:35888 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1CDInw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:43:52 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Guan Xuetao'" <epip@hera.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <greg@kroah.com>
References: <cover.1298821856.git.epip@hera.kernel.org> <b05e05c32279bbb45939006a6bbaf7e7183f14ce.1298821856.git.epip@hera.kernel.org> <201102281617.00462.arnd@arndb.de>
In-Reply-To: <201102281617.00462.arnd@arndb.de>
Subject: RE: [PATCH 13/17] unicore32 io: redefine __REG(x) and re-use readl/writel funcs
Date: Fri, 4 Mar 2011 16:00:55 +0800
Message-ID: <03a101cbda42$4c48b080$e4da1180$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFwUWJwWz5DKqeEVgvooZZn2tVwVwFvvDsaAoQX3q+UtEJRUA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, February 28, 2011 11:17 PM
> To: Guan Xuetao
> Cc: GuanXuetao; linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; greg@kroah.com
> Subject: Re: [PATCH 13/17] unicore32 io: redefine __REG(x) and re-use readl/writel funcs
> 
> On Sunday 27 February 2011, Guan Xuetao wrote:
> > From: GuanXuetao <gxt@mprc.pku.edu.cn>
> >
> >   -- by advice of Arnd Bergmann
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> I was expecting this to get folded into the patches that introduce the files,
> but this way is fine as well.
I want to keep the patches for core and additional architecture files stable, so each usage of old __REG macor
should be replaced by readl/writel and then generating a big patch.

Thanks & Regards.
Guan Xuetao

