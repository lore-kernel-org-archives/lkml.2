Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1LVRlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:41:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60573 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1LVRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:41:47 -0500
Message-ID: <4EF36BDA.5080105@gmail.com>
Date: Thu, 22 Dec 2011 12:41:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: mmap system call does not return EOVERFLOW
References: <4EF2F9EB.7000006@jp.fujitsu.com>
In-Reply-To: <4EF2F9EB.7000006@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The argument "offset" is shifted right by PAGE_SHIFT bits
> in sys_mmap(mmap systemcall).
> 
> ------------------------------------------------------------------------
> sys_mmap(unsigned long addr, unsigned long len,
> 	unsigned long prot, unsigned long flags,
> 	unsigned long fd, unsigned long off)
> {
> 	error = sys_mmap_pgoff(addr, len, prot, flags, fd, off>>  PAGE_SHIFT);
> }
> ------------------------------------------------------------------------

Hm.
Which version are you looking at? Current code seems to don't have
sys_mmap().



