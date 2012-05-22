Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2EVFeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:34:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41781 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2EVFeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:34:06 -0400
Date: Tue, 22 May 2012 13:33:54 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, david.daney@cavium.com
Subject: Re: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with
 irq disabled
Message-ID: <20120522053354.GA12098@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
 <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
 <4FBA1961.2050504@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBA1961.2050504@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 02:30:57PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 21-05-2012 10:00, Yong Zhang wrote:
> 
> >From: Yong Zhang<yong.zhang@windriver.com>
> 
> >To prevent a problem as commit 5fbd036b [sched: Cleanup cpu_active madness]
> >and commit 2baab4e9 [sched: Fix select_fallback_rq() vs cpu_active/cpu_online]
> >try to resolve, move set_cpu_online() to the brought up CPU and with irq
>                                                ^^^^^^^^^^
>    Now the same change in the subject please.

Ah, yes, forgot that.

Thanks,
Yong
