Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2L1TNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:13:41 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54979 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2L1TNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <20121228114720.GB12363@x1.alien8.de>
References: <20121227185126.GA10207@x1.alien8.de>
	<CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
	<20121228114720.GB12363@x1.alien8.de>
Date: Fri, 28 Dec 2012 11:13:32 -0800
X-Google-Sender-Auth: KJF3Ekn_SGguJ2aN9lQTXoTYDL4
Message-ID: <CAE9FiQW9-VQ-1x9Pn3-EkCVRQJEeQdxu-mvPsbm1OmMpdQy9qw@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 3:47 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 27, 2012 at 04:34:03PM -0800, Yinghai Lu wrote:
>> do you like to name it with kernel_ident_mapping_info ?
>
> We have already kernel_ident_mapping_init so the first three words are
> already the same. Besides, you're differentiating between kernel mapping
> or ident mapping so ident_mapping_info is not that suitable too. Maybe
> x86_mapping_info since it is x86-specific?

ok, will use x86_mapping_info.

Thanks a lot.

Yinghai
