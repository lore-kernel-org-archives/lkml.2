Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0KIUu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:50:59 -0500
Received: from freeflow.nu ([178.79.134.28]:53433 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab0KIUuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:50:54 -0500
Message-ID: <4CD9B432.8080305@kernel.org>
Date: Tue, 09 Nov 2010 22:50:58 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
References: <20101109181157.GE5876@outflux.net> <20101109181525.GH5876@outflux.net> <AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com> <20101109191908.GO5876@outflux.net> <AANLkTi=zU=RxqMX_h=BM4WchgCbwTi9tWa0SkhxmDwcg@mail.gmail.com> <20101109195622.GR5876@outflux.net> <AANLkTik3C01Pvv_RvgKXctjKjw=XS4AeEN94ADZtw+sW@mail.gmail.com> <20101109204857.GT5876@outflux.net>
In-Reply-To: <20101109204857.GT5876@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.11.2010 22.48, Kees Cook wrote:
> Hi Pekka,
>
> On Tue, Nov 09, 2010 at 10:28:16PM +0200, Pekka Enberg wrote:
>> So why can't we do patch 2/4 XD_DISABLE clearing in
>> early_init_intel()?
> Because it's too late, unfortunately. I went around a few times about this
> with Peter Anvin, and ultimately he agreed that it needed to go in
> verify_cpu() for now.

OK, thanks for the explanation. A link to the previous discussion would 
have been helpful here.

Acked-by: Pekka Enberg <penberg@kernel.org>

for the whole series.

             Pekka
