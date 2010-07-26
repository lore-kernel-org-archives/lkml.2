Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0GZKdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:33:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55239 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0GZKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:33:00 -0400
Date: Mon, 26 Jul 2010 12:32:56 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4C4D6458.6040402@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10)
 Gecko/20100620 Icedove/3.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to use code coverage measurements with mainline Linux kernel
2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110 board).

I've enabled following in my .config:

   CONFIG_GCOV_KERNEL=y
   CONFIG_DEBUG_FS=y

After successful boot I see no gcov-related files other than
   /sys/kernel/debug/gcov/reset.

 From my knowledge (and from my previous experience with out-of-tree
gcov patchset) whole directory structure shall be created along with
.gcda files and various symlinks.

I haven't used mainline gcov support yet, so maybe there are additional
steps needed to get it going?  Lecture of Documentation/gcov.txt didn't
help much.

Hints?

Thanks in advance.
