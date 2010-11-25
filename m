Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab0KYFg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 00:36:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0KYFg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 00:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T8r9mQt/iOffkOYJstl6NyOi2M03uovmnUSzhC8CAgA+cToI2u9XczCmJgV+eC21fY
         ygOJ+pmZkHu422OoP6EjJsRpaZaafh7X3+NHBn+Gi+AOSSelA3haOwXi3mpJ+MXe2zJa
         lYoOCD6yxbufhW6C3JqoyCljqdXtXHik0LgXM=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=6r_N9wHk1xWQ8Tya34f1eeqjiT5F4jUOf2X8+@mail.gmail.com>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
	<alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
	<AANLkTinOAdDqmVo+zrEk=-EUri-CXBY1kukd96-ocHhL@mail.gmail.com>
	<AANLkTi=6r_N9wHk1xWQ8Tya34f1eeqjiT5F4jUOf2X8+@mail.gmail.com>
Date: Thu, 25 Nov 2010 11:36:25 +0600
Message-ID: <AANLkTin-KUUAx00b3RXAWMM0vBZMWax8kLHYQv8u0A00@mail.gmail.com>
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 7:01 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Nov 24, 2010 at 04:26:01PM +0600, Rakib Mullick wrote:
>> On Wed, Nov 24, 2010 at 3:57 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> I think Jesper is confused because your patch applies on -tip (tip/master or
> tip/perf/core) where we have zapped the bp argument from show_trace() lately.
>
Yes, the patch was made against tip/master.

> But in the mainline, show_trace() still has the bp argument.
>
