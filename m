Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2KPRQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:16:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45432 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2KPRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:16:49 -0500
MIME-Version: 1.0
In-Reply-To: <50A6746D.8070506@zytor.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<1349827115-16600-7-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101733220.2689@kaball.uk.xensource.com>
	<CAE9FiQVuU=KfMM0Q16Lddz8ZL_wzg5PLkWWK=6navQdC_j0KbA@mail.gmail.com>
	<alpine.DEB.2.02.1210101821540.2689@kaball.uk.xensource.com>
	<CAE9FiQVSMP2TpTPxEB62T-uELY-W67m6LX-qTJ7yYSEE-cOZbA@mail.gmail.com>
	<50A6746D.8070506@zytor.com>
Date: Fri, 16 Nov 2012 09:16:47 -0800
X-Google-Sender-Auth: Sc8VdDfxgw4glLEcnk62XjcnlQw
Message-ID: <CAE9FiQUB8GxO4aQnQ9+WNab8WGtMaw-RqwRjzC4EoPwmaew9aA@mail.gmail.com>
Subject: Re: [PATCH 6/7] x86, mm: setup page table from top-down
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 9:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/10/2012 10:38 AM, Yinghai Lu wrote:
>> attached patch on top of this patch will fix the problem?
>>
>
>         .mapping = {
> -               .pagetable_reserve              = native_pagetable_reserve,
> +               .mark_page_ro                   = mark_page_ro_noop;
>         },
>
> I have already objected to this naming in the past, because it describes an
> implementation ("hypervisor make readonly") as opposed to a semantic
> function "make this page permissible to use as a page table".  I would call
> it pagetable_prepare or something like that.

please check v7 series with /46 in the title.
