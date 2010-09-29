Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0I2PFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:05:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab0I2PFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <4CA2FA13.8050405@panasas.com>
References: <4CA09977.80506@panasas.com> <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
 <20100928134721.f79a5955.akpm@linux-foundation.org> <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
 <4CA2FA13.8050405@panasas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Sep 2010 08:05:04 -0700
Message-ID: <AANLkTikX1xWiZ+XROF=CEvkE+BVpv6vk5vzW2BGt-bxq@mail.gmail.com>
Subject: Re: [PATCH] um: Proper Fix for f25c80a4: remove duplicate structure
 field initialization
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 1:34 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> On the other hand patch [f25c80a4] was trying to use eth_mac_addr()
> in eth_configure(), *which was the real fallout*. Because of state
> checks done inside eth_mac_addr() the address was never set. I have
> not reintroduced the memcpy wrapper, but I've put a comment for future
> cats.

Ahh. Ok, this looks fine. David, please use this instead of my broken
one that didn't do the whole thing.

                           Linus
