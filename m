Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab1HSGxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 02:53:21 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:32983 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1HSGxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 02:53:20 -0400
Subject: Re: [PATCH 03/11] arch/unicore32: do not use EXTRA_AFLAGS or
 EXTRA_CFLAGS
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <CACqU3MUVBQ67vKP-41jAy7JGrW1-m+HR8mrt18Yke6ZrjYLx-w@mail.gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
	 <1313384834-24433-4-git-send-email-lacombar@gmail.com>
	 <CACqU3MWTEFy+XV7WH=FEP2hTvBu8VCgcYj-HCcVnSjKxZBQeeA@mail.gmail.com>
	 <1313654457.2905.10.camel@epip-laptop>
	 <CACqU3MUVBQ67vKP-41jAy7JGrW1-m+HR8mrt18Yke6ZrjYLx-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Fri, 19 Aug 2011 14:54:03 +0800
Message-ID: <1313736843.2905.16.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 12:37 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Thu, Aug 18, 2011 at 4:00 AM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> > It looks good for me.
> >
> > Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >
> > Do I need to push the patch into unicore32 repo?
> >
> All patches in the series are fully independent from one another, so
> yes, you can just pick it in the unicore32 tree.
> 
> Thanks,
>  - Arnaud

I see, thanks for your explanation.

Guan Xuetao


