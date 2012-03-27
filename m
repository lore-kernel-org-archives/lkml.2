Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2C0PeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:34:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56330 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab2C0PeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <4F71C54C.7060804@gmail.com>
References: <201203262047.17865.vda.linux@googlemail.com> <4F71C54C.7060804@gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 27 Mar 2012 17:33:55 +0200
Message-ID: <CAK1hOcO7OOEJyEev+5u++piQSU6fW49wEzMagaCoX5_BzvJ=ag@mail.gmail.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 3:49 PM, roma1390 <roma1390@gmail.com> wrote:
> Hi Denys,
>
> Can't compare speed to base, but I tested this test_new on
> 2.6.32-5-kirkwood #1 Tue Jan 17 05:11:52 UTC 2012 armv5tel GNU/Linux
>  ./test_new
> Conversions per second: 8:5528000 123:4568000 123456:3568000
> 12345678:3392000 123456789:1168000 2^32:976000 2^64:532000
> Conversions per second: 8:5524000 123:4568000 123456:3680000
> 12345678:3408000 123456789:1132000 2^32:972000 2^64:532000
> Conversions per second: 8:5028000 123:4416000 123456:3688000
> 12345678:3396000 123456789:1168000 2^32:976000 2^64:512000
> Conversions per second: 8:5524000 123:4572000 123456:3684000
> 12345678:3288000 123456789:1168000 2^32:972000 2^64:532000
> Tested 900988928                               ^Z

Thanks, but without baseline, it's impossible to see whether
we have an improvement...

Can you also let it run longer, to test at least up to
first 5 billion numbers (which is > 2^32)?

-- 
vda
