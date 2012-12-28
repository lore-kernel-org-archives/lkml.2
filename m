Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2L1TMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:12:25 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:44120 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2L1TMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <20121228113925.GA12363@x1.alien8.de>
References: <20121227185126.GA10207@x1.alien8.de>
	<CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
	<CAE9FiQXgDGBsCHPC2m4mDx4JxgKu5tJ0ABMY2jch-1=JUdnm4w@mail.gmail.com>
	<20121228113925.GA12363@x1.alien8.de>
Date: Fri, 28 Dec 2012 11:12:22 -0800
X-Google-Sender-Auth: TMSr4li-xhpbMJ0gLRHTvtUycvw
Message-ID: <CAE9FiQU6tY47MXiwfm0nnGEXetfCJ4muFT3CeLFOJZAdjc6=xQ@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 3:39 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Dec 28, 2012 at 12:13:06AM -0800, Yinghai Lu wrote:
>> so will stay with alloc.
>
> "alloc" is too generic. So call it 'get_one_pgt_page' or
> 'alloc_pgt_page' or something descriptive to say what it does than
> simply 'alloc'. 'alloc' can be anything - it could mean allocation hints
> or flags or whatever you feel like at that particular time of day :-).

alloc_pgt_page should be ok.
