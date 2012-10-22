Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2JVTSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:18:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42281 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2JVTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121022151411.GE22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-15-git-send-email-yinghai@kernel.org>
	<20121022151411.GE22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:18:48 -0700
X-Google-Sender-Auth: I6VUatq8ta0UiqNfF9Tsx2wk1D0
Message-ID: <CAE9FiQUM=RG17Z6y586MzCeKnp8w_Ltf0z4Os2MKz42h6WKCUQ@mail.gmail.com>
Subject: Re: [PATCH 11/19] x86, mm, xen: Remove mapping_pagatable_reserve
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

On Mon, Oct 22, 2012 at 8:14 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:22PM -0700, Yinghai Lu wrote:
>> page table area are pre-mapped now, and mark_page_ro is used to make it RO
>   ^ Page     ^^^^->areas                  ^^^^^^^^^^^-> ? I must have
> missed that patch. Can you include the title of the patch in this
> git commit so one could take a look.

sorry, forget to remove those words.

new version:
---
Page table area are pre-mapped now after
        x86, mm: setup page table in top-down
        x86, mm: Remove early_memremap workaround for page table
accessing on 64bit

mapping_pagetable_reserve is not used anymore, so remove it.
---
