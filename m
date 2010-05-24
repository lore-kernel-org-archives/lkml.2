Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0EXHGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:06:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45763 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab0EXHGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:06:11 -0400
Content-Type: text/plain; charset=UTF-8
Cc: fweisbec <fweisbec@gmail.com>, mingo <mingo@elte.hu>,
       rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       laijs <laijs@cn.fujitsu.com>, lizf <lizf@cn.fujitsu.com>,
       hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       mhiramat <mhiramat@redhat.com>,
       "heiko.carstens" <heiko.carstens@de.ibm.com>,
       benh <benh@kernel.crashing.org>, davem <davem@davemloft.net>,
       lethal <lethal@linux-sh.org>, schwidefsky <schwidefsky@de.ibm.com>,
       brueckner <brueckner@linux.vnet.ibm.com>,
       "tony.luck" <tony.luck@intel.com>
Subject: Re: [PATCH 07/14] syscalls: add ARCH_COMPAT_SYSCALL_DEFINE()
From: Ian Munsie <imunsie@au1.ibm.com>
To: Jason Baron <jbaron@redhat.com>
In-reply-to: <cbd14095e98f80fd05d3e8e76111572072e565bc.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com> <cbd14095e98f80fd05d3e8e76111572072e565bc.1268749695.git.jbaron@redhat.com>
Date: Mon, 24 May 2010 17:05:42 +1000
Message-Id: <1274684482-sup-7551@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Jason Baron's message of Wed Mar 17 04:46:42 +1100 2010:
<snip>
> +    SYSCALL_METADATA(syscall, compat_sys_##sname, x);    \
> +    asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
> +#else
> +#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)            \

I think that should be:
#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)

To avoid breaking archs without compat syscalls.

Cheers,
-Ian
