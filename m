Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2K1U1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:27:07 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57549 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2K1U1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:27:03 -0500
MIME-Version: 1.0
In-Reply-To: <1353716453-9693-1-git-send-email-acme@infradead.org>
References: <1353716453-9693-1-git-send-email-acme@infradead.org>
Date: Wed, 28 Nov 2012 15:27:02 -0500
Message-ID: <CA+5PVA4dMd8ZfN6OgDQXvFxSPSN3+Cim27ZypWni3ihErSE7tQ@mail.gmail.com>
Subject: Re: [GIT PULL 0/8] perf/urgent fixes
From: Josh Boyer <jwboyer@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>, linux-arch@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 7:20 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Hi Ingo,
>
>         Tested using a cross-compiler and directly on a Raspberry pi (ARM) with
> raspbian.
>
>         Please consider pulling.
>
> - Arnaldo
>
> The following changes since commit 18423d3562f396206e0928a71177eeb2edfed077:
>
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2012-11-13 18:51:51 +0100)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
>
> for you to fetch changes up to 7321090f6751c9987c26a8c81c63680d16a614d7:
>
>   perf kvm: Fix building perf kvm on non x86 arches (2012-11-23 20:40:17 -0300)
>
> ----------------------------------------------------------------
> perf/urgent fixes
>
> . Don't build 'perf kvm stat" on non-x86 arches, fix from Xiao Guangrong.
>
> . UAPI fixes to get perf building again in non-x86 arches, from David Howells.
>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       Merge tag 'perf-uapi-20121119' of git://git.infradead.org/users/dhowells/linux-headers into perf/urgent
>
> David Howells (6):
>       x86: Export asm/{svm.h,vmx.h,perf_regs.h}
>       Merge branch 'x86-pre-uapi' into perf-uapi
>       tools: Define a Makefile function to do subdir processing
>       tools: Honour the O= flag when tool build called from a higher Makefile
>       tools: Pass the target in descend
>       perf: Make perf build for x86 with UAPI disintegration applied
>
> Sukadev Bhattiprolu (1):
>       perf powerpc: Use uapi/unistd.h to fix build error
>
> Xiao Guangrong (2):
>       perf kvm: Rename perf_kvm to perf_kvm_stat
>       perf kvm: Fix building perf kvm on non x86 arches

I probably sound like a broken record at this point, but I've not seen
this go into any tip branch, nor is it in Linus' tree.  Hopefully this
gets pulled before 3.7 is released.

josh
