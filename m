Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0CZCK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:10:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:58270 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0CZCK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:10:28 -0400
Date: Fri, 26 Mar 2010 11:10:08 +0900
To: airlied@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, ben@decadent.org.uk, airlied@linux.ie,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <21d7e9971003251845i24af9712qb64aa3ca5f8f042c@mail.gmail.com>
References: <1269401628.18314.264.camel@localhost>
	<20100326104042T.fujita.tomonori@lab.ntt.co.jp>
	<21d7e9971003251845i24af9712qb64aa3ca5f8f042c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100326110946V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Mar 2010 11:10:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 11:45:50 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Fri, Mar 26, 2010 at 11:41 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Wed, 24 Mar 2010 03:33:48 +0000
> > Ben Hutchings <ben@decadent.org.uk> wrote:
> >
> >> SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
> >> amd64-agp is apparently preferable since it has workarounds for some
> >> BIOS misconfigurations that sis-agp doesn't handle.
> >>
> 
> Will this not cause problems in 32-bit kernels?

I'm not sure. I thought that amd64-agp works on 32-bit kernels since
fix_northbridge() in amd64-agp.c has the comment that the function is
used on 64-bit and 32-bit kernels. We need someone who can test the
patch.
