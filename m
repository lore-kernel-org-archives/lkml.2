Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0I2PIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:08:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621Ab0I2PIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:08:34 -0400
MIME-Version: 1.0
In-Reply-To: <4CA2FBBB.3040004@panasas.com>
References: <4CA09977.80506@panasas.com> <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
 <20100928134721.f79a5955.akpm@linux-foundation.org> <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
 <4CA2FBBB.3040004@panasas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Sep 2010 08:01:07 -0700
Message-ID: <AANLkTi=aqtzLskpTeZkQwEGRg9jb=NJ8UcQG=vkdc20z@mail.gmail.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 1:41 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> With this I'm now back to my usual: boots fine but half of the times
> not halting. But I think that's a Fedora12 problem with interaction
> with uml. (Which I do not have time to investigate)

So that "half of the time not halting" happened with the revert too?
If so, we should just do the fix. Thanks for testing.

                                              Linus
