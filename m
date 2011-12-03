Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1LCGyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 01:54:37 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63627 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1LCGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 01:54:35 -0500
MIME-Version: 1.0
In-Reply-To: <CABexPfGnGm=qa-SVhD_z+Wmhp31Of2X4s9LmuR32K+FH6jo9Bw@mail.gmail.com>
References: <CABexPfGvJB-Fvx2SbUbJaBVouAkv3UVmmfsTpp_zE8whpHVZEw@mail.gmail.com>
	<CAMzpN2haQjckBGkA1ujaCD0iehAsC2S-xO7eN89S+u+FQ65zXw@mail.gmail.com>
	<CABexPfERzvC+f7S2s8YUrN-Zk_O+6r-mCijSo4B3i+j5G1hfAg@mail.gmail.com>
	<CABexPfEhd39nvypacU1c_mr1+yygqZuq9ZfxEtm1YAY_D21OLQ@mail.gmail.com>
	<CABexPfGnGm=qa-SVhD_z+Wmhp31Of2X4s9LmuR32K+FH6jo9Bw@mail.gmail.com>
Date: Sat, 3 Dec 2011 01:54:34 -0500
Message-ID: <CAMzpN2heyNKNryBgHJv__Nbkr9QQJuCBrpSDj=tSd-yuHqaowA@mail.gmail.com>
Subject: Re: [Provisional Page Table] Why the linear address ranges starting
 both from 0 and PAGE_OFFSET are mapped to the same physical address range in
 the provisional page table?
From: Brian Gerst <brgerst@gmail.com>
To: zhihua che <zhihua.che@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 12:27 AM, zhihua che <zhihua.che@gmail.com> wrote:
> Here is another relating question. Why the provisional page table is
> stored at initial_page_table while final page table is store at
> swapper_pg_dir, I think only one page directory table is enough,
> because the two page table are not effective in the same time, it's
> enough to construct the provisional page table at swapper_pg_dir, then
> clear it and construct the final page table. And I find that in the
> previous linux kernel, only swapper_pg_dir is present.

See commits fd89a137924e0710078c3ae855e7cec1c43cb845 and
b40827fa7268fda8a62490728a61c2856f33830b for the explanation of why
they are seperate.

--
Brian Gerst
