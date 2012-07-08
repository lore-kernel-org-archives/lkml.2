Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2GHCdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 22:33:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44650 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GHCdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 22:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
Date: Sun, 8 Jul 2012 11:33:14 +0900
Message-ID: <CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order 0
From: JoonSoo Kim <js1304@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/7 David Rientjes <rientjes@google.com>:
> On Sat, 7 Jul 2012, Joonsoo Kim wrote:
>
>> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
>> And in almost invoking case, order is 0, so return immediately.
>>
>
> If "zero cost" is "very costly", then this might make sense.
>
> __alloc_pages_direct_compact() is inlined by gcc.

In my kernel image, __alloc_pages_direct_compact() is not inlined by gcc.
So I send this patch.
But, currently I think it is not useful, so drop it.

Thanks for comments.
