Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2L0X7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:59:24 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34212 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2L0X7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:59:21 -0500
MIME-Version: 1.0
In-Reply-To: <20121227190351.GA10819@x1.alien8.de>
References: <20121227185126.GA10207@x1.alien8.de>
	<20121227190351.GA10819@x1.alien8.de>
Date: Thu, 27 Dec 2012 15:59:20 -0800
X-Google-Sender-Auth: Ozl_KCVJeXuLwrxdGD0cqxhmKpU
Message-ID: <CAE9FiQXWpbee0F-RD_OrxV_JRh-yoO1pcf5qDa+9_qONrCGhPg@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 11:03 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 27, 2012 at 07:51:26PM +0100, Borislav Petkov wrote:
>> > commit bb3cda32f9586e13c5d3dde6c83a914bb2d7f87f
>> > Author: Yinghai Lu <yinghai@kernel.org>
>> > Date:   Mon Dec 24 18:00:21 2012 -0800
>> >
>> >     x86, mm: add generic kernel/ident mapping helper
>> >
>> >     It is simple version for kernel_physical_mapping_init.
>> >     it will work to build one page table that will be put effectiv later.
>
> Forgot to ask: what does "put effectiv later" mean?

 * we will switch to using it later
