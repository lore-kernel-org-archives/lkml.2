Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0DLMk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab0DLMk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:40:28 -0400
Message-ID: <4BC314A8.80904@redhat.com>
Date: Mon, 12 Apr 2010 08:40:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ian Munsie <imunsie@au1.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf probe: Add PowerPC DWARF register number mappings
References: <1271054596-26561-1-git-send-email-imunsie@au.ibm.com> <1271054596-26561-2-git-send-email-imunsie@au.ibm.com> <1271054596-26561-3-git-send-email-imunsie@au.ibm.com>
In-Reply-To: <1271054596-26561-3-git-send-email-imunsie@au.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

Ian Munsie wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> This patch adds mappings from the register numbers from DWARF to the
> register names used in the PowerPC Regs and Stack Access API. This
> allows perf probe to be used to record variable contents on PowerPC.
> 
> This patch depends on functionality in the powerpc/next tree, though it
> will compile fine without it. Specifically this patch depends on
> 359e4284a3f37aba7fd06d993863de2509d86f54
> 
> Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
> ---
>  tools/perf/arch/powerpc/Makefile                  |    1 +
>  tools/perf/arch/powerpc/include/arch_dwarf-regs.h |    6 ++
>  tools/perf/arch/powerpc/util/dwarf-regs.c         |   88 +++++++++++++++++++++
>  3 files changed, 95 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/arch/powerpc/Makefile
>  create mode 100644 tools/perf/arch/powerpc/include/arch_dwarf-regs.h
>  create mode 100644 tools/perf/arch/powerpc/util/dwarf-regs.c
> 
> diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
> new file mode 100644
> index 0000000..1191403
> --- /dev/null
> +++ b/tools/perf/arch/powerpc/Makefile
> @@ -0,0 +1 @@
> +LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
> diff --git a/tools/perf/arch/powerpc/include/arch_dwarf-regs.h b/tools/perf/arch/powerpc/include/arch_dwarf-regs.h
> new file mode 100644
> index 0000000..a7fc588
> --- /dev/null
> +++ b/tools/perf/arch/powerpc/include/arch_dwarf-regs.h
> @@ -0,0 +1,6 @@
> +#ifndef _PREF_ARCH_X86_DWARF_REGS_H
> +#define _PREF_ARCH_X86_DWARF_REGS_H

_PREF_ARCH_PPC_DWARF_REGS_H? :)

> +
> +#define get_arch_regstr(n) get_arch_regstr(n)
> +
> +#endif

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
