Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2FWArC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:47:02 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61097 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab2FWArA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120622111131.GB18249@linux-mips.org>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
	<1340334073-17804-12-git-send-email-chenhc@lemote.com>
	<87txy3sn20.fsf@lebrac.rtp-net.org>
	<CAAhV-H5q5G87UMn0ixPUVZNcEV1b_qBHJKVKmCJsmzKdEB--4A@mail.gmail.com>
	<20120622111131.GB18249@linux-mips.org>
Date: Sat, 23 Jun 2012 08:46:59 +0800
Message-ID: <CAAhV-H6nbB_QNC9Qm0AwgNeUyWK7iRQmKQRLNXiEjHR1Zdyejw@mail.gmail.com>
Subject: Re: [PATCH V3 11/16] drm/radeon: Make radeon card usable for Loongson.
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 7:11 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Fri, Jun 22, 2012 at 06:55:40PM +0800, Huacai Chen wrote:
>
>> > btw, would it be a good idea to use uncached accelerated instead ?
>> I have tried uncached accelerated, there will be random points in the
>> monitor, it seems a hw issue...
>
> Have you flushed the pages from memory before switching their cache mode
> to uncached accelerated?  The MIPS architecture defines the result of
> mixing cache modes as UNPREDICTABLE so be careful to flush caches before
> switching cache mode of a page.
Not because of flushing, CPU designing team told us a method but very
complex, and that method will cause other performance drop. So, we
won't use uncached accelerate mode.
>
>  Ralf
