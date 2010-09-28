Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0I1VJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:09:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab0I1VJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <20100928.140014.115950817.davem@davemloft.net>
References: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
 <20100928134721.f79a5955.akpm@linux-foundation.org> <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
 <20100928.140014.115950817.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Sep 2010 14:08:35 -0700
Message-ID: <AANLkTinyPHP2wQvCiZnN3QkX96LM_25GiLpn0by6jfXo@mail.gmail.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, bharrosh@panasas.com, julia@diku.dk,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 2:00 PM, David Miller <davem@davemloft.net> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 28 Sep 2010 13:57:04 -0700
>
>> So perhaps something like the attached patch would make it work, and
>> have the locking in place that apparently people think it should have?
>
> I'm fine with this if it works:
>
> Acked-by: David S. Miller <davem@davemloft.net>

And you can add my sign-off to it if somebody tests it.

It does look like the obvious fix. The "wrapper" is simply totally
wrong as-is, and passes the wrong thing entirely to eth_mac_addr()
afaik.

                Linus
