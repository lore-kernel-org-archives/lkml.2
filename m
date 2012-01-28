Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2A1PTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:19:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65139 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2A1PTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:19:15 -0500
Message-ID: <4F2411D8.2060301@gmail.com>
Date: Sat, 28 Jan 2012 23:18:48 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Djalal Harouni <tixxdz@opendz.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kcore: make get_sparsemem_vmemmap_info static
References: <20120126223723.GA20412@dztty>
In-Reply-To: <20120126223723.GA20412@dztty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 06:37 AM, Djalal Harouni wrote:
> get_sparsemem_vmemmap_info() is only used inside fs/proc/kcore.c
>
> Signed-off-by: Djalal Harouni<tixxdz@opendz.org>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

