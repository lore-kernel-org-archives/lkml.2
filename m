Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2LMCP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:15:27 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57899 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2LMCP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:15:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121212.151116.143443755590581447.davem@davemloft.net>
References: <20121212.151116.143443755590581447.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 18:15:04 -0800
X-Google-Sender-Auth: UNcONES4ivDoFOBFP01MWxRliNk
Message-ID: <CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 12:11 PM, David Miller <davem@davemloft.net> wrote:
>
> There is one merge conflict to resolve in net/sched/cls_cgroup.c,
> one commit changes the name of some members to "css_*" (this came
> from Tejun's tree) and another commit adds an "attach" method.

There's more than that. The ARM board mess is apparently now affecting
the networking merges too.

I fixed it up. Hopefully correctly.

Also, why does the new SHA1 hmac cookie support default to 'y'?

                  Linus
