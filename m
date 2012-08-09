Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031185Ab2HIPrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:47:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:32887 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030969Ab2HIPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:47:08 -0400
Message-ID: <5023DB76.1030908@gmail.com>
Date: Fri, 10 Aug 2012 00:47:02 +0900
From: "J.Hwan Kim" <frog1120@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: allocation of contiguous memory in kernel mode
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

I wish to alloc physically contiguous memory in kernel mode.
I used the __get_free_pages(gfp_mask, order) function,
but it fails occasionary.
I guess it is caused by memory fragmentation.
My code is kernel driver module which cannot use
bootmem allocation and its platform is x86_64.
My server desktop has 20GB memory.
I wish to know the method to allocate physically
contiguous memory not failing by fragmentation.

Thanks in advance.

Best Regards,
J.Hwan Kim

