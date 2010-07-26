Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0GZKhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:37:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55565 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0GZKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:37:11 -0400
Date: Mon, 26 Jul 2010 12:37:08 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
In-reply-to: <4C4D6458.6040402@samsung.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Message-id: <4C4D6554.30707@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10)
 Gecko/20100620 Icedove/3.0.5
References: <4C4D6458.6040402@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
> Hello,
>
> I'm trying to use code coverage measurements with mainline Linux kernel
> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110 board).
>
> I've enabled following in my .config:
>
> CONFIG_GCOV_KERNEL=y
> CONFIG_DEBUG_FS=y
>
> After successful boot I see no gcov-related files other than
> /sys/kernel/debug/gcov/reset.
>
>  From my knowledge (and from my previous experience with out-of-tree
> gcov patchset) whole directory structure shall be created along with
> .gcda files and various symlinks.

I forgot to add that I've added "GCOV_PROFILE := y" to at least

   fs/Makefile
   kernel/Makefile

and few others.  Thus, I expect to find something more than just
./reset file.
