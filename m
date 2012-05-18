Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab2ERMov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:44:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44890 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966197Ab2ERMot convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <4FB60C7A.2080508@linux.vnet.ibm.com>
References: <4FB60C7A.2080508@linux.vnet.ibm.com>
Date: Fri, 18 May 2012 14:44:47 +0200
Message-ID: <CABPqkBR=otfRebYYh+aZP79YMGYzX384VHYK82JoBLcbbctRnw@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fixing perf-record documentation for branch
 stack sampling
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:46 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> perf tools: Fixing perf-record documentation for branch stack sampling
>
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  tools/perf/Documentation/perf-record.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index a1386b2..b38a1f9 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -168,7 +168,7 @@ following filters are defined:
>         - any:  any type of branches
>         - any_call: any function call or system call
>         - any_ret: any function return or system call return
> -        - any_ind: any indirect branch
> +        - ind_call: any indirect branch
>         - u:  only when the branch target is at the user level
>         - k: only when the branch target is in the kernel
>         - hv: only when the target is at the hypervisor level
>
