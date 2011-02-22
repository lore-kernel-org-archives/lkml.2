Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1BVMEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:04:32 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43950 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1BVMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:04:31 -0500
X-AuditID: b753bd60-a2ec6ba0000066fd-6e-4d63a64cf0f0
X-AuditID: b753bd60-a2ec6ba0000066fd-6e-4d63a64cf0f0
Message-ID: <4D63A642.5090203@hitachi.com>
Date: Tue, 22 Feb 2011 21:04:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -perf/perf/makefile  0/2] Perf bugfixes for cross-builds
References: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

BTW, could you pull these patches for cross building?

(2011/02/10 11:28), Masami Hiramatsu wrote:
> Hi,
> 
> Here are some bugfixes related to cross builds.
> - Introduce ARCH=XX for cross-builds instead of obsolate
>   EXTRA_CFLAGS=-mXX option.
> - Rename obsolate NO_PERL to NO_LIBPERL
> 
> Still not sure how I can do cross-builds i386 binary with
> perl/python support on x86-64. Anyway, now we can do without
> that as below;
> 
>  $ make ARCH=i386 NO_LIBPERL=1 NO_LIBPYTHON=1
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (2):
>       perf tools: Rename old NO_PERL option to NO_LIBPERL
>       perf tools: Introduce ARCH= option for cross building
> 
> 
>  tools/perf/Makefile              |   48 +++++++++++++++++++++++++-------------
>  tools/perf/arch/arm/Makefile     |    2 +-
>  tools/perf/arch/powerpc/Makefile |    2 +-
>  tools/perf/arch/s390/Makefile    |    2 +-
>  tools/perf/arch/sh/Makefile      |    2 +-
>  tools/perf/arch/sparc/Makefile   |    2 +-
>  tools/perf/arch/x86/Makefile     |    2 +-
>  7 files changed, 38 insertions(+), 22 deletions(-)
> 


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
