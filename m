Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2C2Kd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:33:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62983 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2C2KdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <4F73F042.1010400@gmail.com>
References: <201203262047.17865.vda.linux@googlemail.com> <4F71C54C.7060804@gmail.com>
 <CAK1hOcO7OOEJyEev+5u++piQSU6fW49wEzMagaCoX5_BzvJ=ag@mail.gmail.com> <4F73F042.1010400@gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 29 Mar 2012 12:33:00 +0200
Message-ID: <CAK1hOcN4WUi_3eg=eYsMZs1McuY0P-9oBa6MMUqOpjwKAvqfVA@mail.gmail.com>
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

On Thu, Mar 29, 2012 at 7:16 AM, roma1390 <roma1390@gmail.com> wrote:
> On 2012.03.27 18:33, Denys Vlasenko wrote:
>>
>> Can you also let it run longer, to test at least up to
>> first 5 billion numbers (which is>  232)?
>
> First test after ~20 hour run:
> Tested 12514754560

Looks like it's ok :)

In case you expect that it will finish: well, it won't.
It will roll over 2^64-1 after a few years, and start from 0 :) :)
So please feel free to ^C

-- 
vda
