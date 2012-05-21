Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab2EUKbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:31:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63405 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab2EUKba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:31:30 -0400
Message-ID: <4FBA1961.2050504@mvista.com>
Date: Mon, 21 May 2012 14:30:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, david.daney@cavium.com
Subject: Re: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with
 irq disabled
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com> <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-05-2012 10:00, Yong Zhang wrote:

> From: Yong Zhang<yong.zhang@windriver.com>

> To prevent a problem as commit 5fbd036b [sched: Cleanup cpu_active madness]
> and commit 2baab4e9 [sched: Fix select_fallback_rq() vs cpu_active/cpu_online]
> try to resolve, move set_cpu_online() to the brought up CPU and with irq
                                                ^^^^^^^^^^
    Now the same change in the subject please.

> disabled.

> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: David Daney <david.daney@cavium.com>

WBR, Sergei
