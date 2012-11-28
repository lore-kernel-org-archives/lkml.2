Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2K1Try (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:47:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60761 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2K1Trx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:47:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121128193523.GA18843@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
	<20121127211755.GC10391@phenom.dumpdata.com>
	<20121128193523.GA18843@phenom.dumpdata.com>
Date: Wed, 28 Nov 2012 11:47:51 -0800
X-Google-Sender-Auth: DW-nI5qMsogal_FUKI9c0bM3w44
Message-ID: <CAE9FiQW4AiB_PdZ4UkZ9iKe0Tv-+OWzn=pJCaOvU6W1m-gPhaQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/46] x86, mm: map ram from top-down with BRK and memblock.
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:35 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> Have done so. I really like how the top-down mechanism works. It is pretty neat!
>
> Yinghai, I had mostly just comments about the patch descriptions -  I would
> appreciate it you could modify the patches to address the little nitpicks I
> spotted. And while doing that you can stick
> 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>' on all patches.
>
> For the "x86, mm, Xen: Remove mapping_pagetable_reserve()"
> you can also put 'Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'

Thanks a lot for reviewing. Will update those changelog, and add
acked-by and reviewed by...

BTW, can you please check my for-x86-boot branch that will allow
bzImage to be loaded above 4G on 64bit platform by 64 bit bootloader.
Hope it does not break Xen dom0 and domU.

Yinghai
