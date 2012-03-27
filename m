Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2C0DSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:18:01 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:45687 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab2C0DR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:17:59 -0400
Message-ID: <4F71319F.60605@mprc.pku.edu.cn>
Date: Tue, 27 Mar 2012 11:18:55 +0800
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Kautuk Consul <consul.kautuk@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/20] unicore32/mm/fault.c: Port OOM changes to do_pf
References: <1332249906-3106-1-git-send-email-consul.kautuk@gmail.com>
In-Reply-To: <1332249906-3106-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 09:25 PM, Kautuk Consul wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
>
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
>
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>
> Port these changes to unicore32.
>
> Signed-off-by: Kautuk Consul<consul.kautuk@gmail.com>
> ---
>
Sorry for replying so late.

I've tested the patch for compilation and running, but not triggered 
VM_FAULT_RETRY.

Regards,

Guan Xuetao
