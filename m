Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2LJDPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:15:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38694 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2LJDPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:15:39 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 11:15:38 +0800
Message-ID: <CAOZoOZX0RwtsG5DYuCToKs50BWvzBe+Pr=GR-wr9EpkHO1wGwQ@mail.gmail.com>
Subject: 
From: yanchao wu <1446206@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanse,

               I am reading the drive/base/memory.c that you the
maintainer of it. I met a

problem, could you help me with it?

                My panic is following:  BUG: soft lockup - CPU#0 stuck
for 22s! [swapper:1]

. This is a warning from watch dog .  My platform is 4tb memory ,
64bit x86, SLES sp2

3.0.13 kernel.

In the beginning, I found that a unnecessary search method named
“find_ memory_block”

then  removed( similar with one commit I found later). It reduced time
from 50s to30s.

Unluckily ,still show the panic.   I think the most expensive cost is
register process.

Because in 4TB  64bit, there are about 320000 block to register.   If
we can reduce the

block number, then the time cost will be smaller. So my another
propose is to make block

size bigger,  then sections_per_block will bigger, then more sections
belong to one block ,

then less block to register ,then less time will cost.

               Is my propose suitable? If  yes, how to change the block size.





Best regards,

Yanchao
