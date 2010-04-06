Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0DFXz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:55:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:50523 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0DFXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:55:55 -0400
Date: Wed, 7 Apr 2010 08:55:12 +0900
To: haavard.skinnemoen@atmel.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 02/12] avr32: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100406153808.05637d00@hskinnemoen-d830>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1270511567-18567-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100406153808.05637d00@hskinnemoen-d830>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100407085429T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 07 Apr 2010 08:55:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 15:38:08 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> It's a bit difficult to review without context, but assuming this
> doesn't make struct scatterlist any larger:
> 
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Thanks!

Yeah, the size of struct scatterlist doesn't change. You can find
asm-generic/scatterlist.h in my patchset:

http://git.kernel.org/?p=linux/kernel/git/tomo/linux-2.6-misc.git;a=blob;f=include/asm-generic/scatterlist.h;h=5de07355fad492b10b15227e7959f7cc08e6b044;hb=refs/heads/sc
