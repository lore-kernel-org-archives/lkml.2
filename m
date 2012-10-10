Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2JJPnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:43:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63054 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2JJPm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <20121010135529.GD4005@phenom.dumpdata.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<1349827115-16600-6-git-send-email-yinghai@kernel.org>
	<20121010135529.GD4005@phenom.dumpdata.com>
Date: Wed, 10 Oct 2012 08:42:57 -0700
X-Google-Sender-Auth: gLLxOcryCIcBZc2Aa4xpSDMobXY
Message-ID: <CAE9FiQVVJxr6TX7=Jk8A1NQ7pA=9LtwGxS_3ZCnB9=vCaiSi6g@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86, mm: Break down init_all_memory_mapping
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

On Wed, Oct 10, 2012 at 6:55 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Tue, Oct 09, 2012 at 04:58:33PM -0700, Yinghai Lu wrote:
>> Will replace that will top-down page table initialization.
>
> s/will/with?
>
>> new one need to take range.
>
> Huh? I have no idea what this patch does from your description.
> It says it will replace something (not identified) with
> top-down table initialization.
>
> And the code is not that simple - you should explain _how_ you
> are changing it. From what it did before to what it does _now_.

I tried to make the next patch to be little smaller, so split this change out.
