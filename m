Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0HTJkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:40:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0HTJkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:40:49 -0400
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Zeno Davatz <zdavatz@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org
In-Reply-To: <20100820093226.GA7371@brouette>
References: <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	 <4C3F2F52.2050101@cs.helsinki.fi> <20100715162805.GA10240@brouette>
	 <20100715191638.GA3694@brouette>
	 <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
	 <20100715200012.GA4175@brouette>
	 <AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com>
	 <1280826359.1923.440.camel@laptop>
	 <AANLkTi=VuLwcmjTpOeK-OzgiWeycu14hJpfUuH9cKnUj@mail.gmail.com>
	 <1280826924.4c57de2c3a6b0@imp.free.fr>  <20100820093226.GA7371@brouette>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 11:40:26 +0200
Message-ID: <1282297226.2605.733.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 11:32 +0200, Damien Wyart wrote:

> After a few days of running 2.6.35.2 without problem, 

>  I am surprised so few people reported it and
> that it has not been seen on test machines running CPU/scheduler
> benchmark tools.
> 
My machines are lucky if a kernel has hours of runtime, days almost
never happens, there's always the next kernel to test ;-)

But yeah, you'd expect more people to run into something like this..

Most odd thing..
