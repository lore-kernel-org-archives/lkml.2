Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2EVWCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:02:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42887 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754348Ab2EVWCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:02:03 -0400
Message-ID: <1337724118.11918.2.camel@joe2Laptop>
Subject: Re: [GIT PATCH] driver core patches for 3.5-rc1 - try 2
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 22 May 2012 15:01:58 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending cc'ing lkml)
(Also, apologies about no in-reply-to, lkml.org is down)

While there are several things I like about the
printk modifications, (binary header, delta time,
slightly better partial message deinterleaving,
global msg_id, kmsg is ok too), I am concerned
about the utility and expectations for the new
[v]printk_emit functions.

I think it is not really ready to be merged
at this time.

The commit sequencing was unclean.

The original commit originally required KERN_CONT
and it was modified by another commit to return
to the current behavior.

What really are the expectations and true use-cases
for [v]printk_emit?

How is it really better that what is available now?

Perhaps it would be better to respin all the
printk modifications without adding [v]printk_emit
and have the [v]printk_emit bits debated a bit more.


