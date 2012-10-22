Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2JVTJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:09:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46167 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2JVTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:09:50 -0400
MIME-Version: 1.0
In-Reply-To: <20121022150916.GC22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-12-git-send-email-yinghai@kernel.org>
	<20121022150916.GC22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:09:48 -0700
X-Google-Sender-Auth: gmfG-XYrqJOzvUD_kX3SBtbrB2I
Message-ID: <CAE9FiQUV0idzyN7zG7pnS-MndxqyrRACziYT79oF4wLnmB1SSw@mail.gmail.com>
Subject: Re: [PATCH 08/19] x86, mm: Remove parameter in alloc_low_page for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:09 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:19PM -0700, Yinghai Lu wrote:
>> Now all page table buf are pre-mapped, and could use virtual address directly.
>                      ^^ buffers              ^^^^ -> can
>
>> So don't need to remember physics address anymore.
>   ^^ We
>
> physics? Physical.

ok.
