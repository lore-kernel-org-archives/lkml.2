Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0EQTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0EQTZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:25:03 -0400
Message-ID: <4BF197F3.1030803@redhat.com>
Date: Mon, 17 May 2010 15:24:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: eranian@google.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix Makefile check for libdward
References: <4bf194a4.5cebd80a.2e1f.ffffcc32@mx.google.com>
In-Reply-To: <4bf194a4.5cebd80a.2e1f.ffffcc32@mx.google.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

Stephane Eranian wrote:
> On Ubuntu 9.10, the elfutils/libdw package is 0.141, yet it is
> not sufficient to compile util/probe-finder.c as it uses a type,
> namely Dwarf_CFI, which is introduced sometime after version 0.141.
> 
> This patch updates the libdwarf test in the Makefile to check
> for the definition of Dwarf_CFI. If is is not there, the test
> fails and dwarf support is disabled.
> 
> It is not clear to me which version introduces Dwarf_CFI,
> thus I adjusted the version message to 0.142, could be more
> recent.

Yeah, I see. I had sent a fix patch which just ignores Dwarf_CFI
related code if the libdw version is younger than supporting it.
Could you try the patch here?

https://patchwork.kernel.org/patch/98216/

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
