Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab2CJCOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:14:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47423 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2CJCOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120309163739.GA9545@kroah.com>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
	<20120308184954.GA1275@kroah.com>
	<CACRpkdY3A_k_ywWgnFYG_3Jp+EssfULO0R59=GWUG2a0VS3--g@mail.gmail.com>
	<20120309163739.GA9545@kroah.com>
Date: Sat, 10 Mar 2012 11:14:36 +0900
Message-ID: <CAOAMb1Bpx4ucHgKy+oT2rvt16cubFR3Vi8o3fjwrT65DdJko_Q@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Chanho Min <chanho0207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> To me it seems Russell's patch solves part of the problem,
>> and Jong-Sung Kim's patch on top of that solves the entire
>> problem, but Chanho need to come back and tell whether
>> this is the case in practice.
>
> Ok, then, once it is tested, can someone resend them to me?
>
> thanks,
>
> greg k-h

I checked that Jong-Sung Kim's patch solved this hang-up issue
and agree on it. But, RTIS seems to be cleared as well.
