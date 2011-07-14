Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1GNQ4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:56:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46520 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1GNQ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTzLmSTSMOY-0Xg0tE-DEbZ6RNA+uh70Dn3K5CbrjQsEiA@mail.gmail.com>
References: <CAJ8eaTzLmSTSMOY-0Xg0tE-DEbZ6RNA+uh70Dn3K5CbrjQsEiA@mail.gmail.com>
Date: Thu, 14 Jul 2011 09:56:34 -0700
Message-ID: <CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
Subject: Re: ARM cortex A9 feature
From: Dave Hylands <dhylands@gmail.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Wed, Jul 13, 2011 at 11:26 PM, naveen yadav <yad.naveen@gmail.com> wrote:
> Hi All,
>
> I am reading ARM cortex a9 manual and got few question in mind.
>
> 1. Where I need strong order type memory ? any sample example is very helpfull.

Often when dealing with hardware, you need to ensure that when your code does:

reg1 = val1;
reg2 = val2;

that these writes actually occur in the order that the code issues
them. Using volatile pointers will get the compiler to not reorder the
instructions, but you still need the writes to hit the hardware in the
same order that they were issued. Using strongly ordered memory is one
way to achieve that.

> 2. L2 cache, Cortex a9 support exclusive L2 cache feature, where we need it ?

L2 cache can improve your performance.

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.davehylands.com
