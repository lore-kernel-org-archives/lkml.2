Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0J3TMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:12:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42322
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab0J3TMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:12:17 -0400
Date: Sat, 30 Oct 2010 12:12:38 -0700 (PDT)
Message-Id: <20101030.121238.189687981.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, ebiederm@xmission.com,
        eric.dumazet@gmail.com, tj@kernel.org, serge@hallyn.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: scm: fix information leak to userland
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288448796-6147-1-git-send-email-segooon@gmail.com>
References: <1288448796-6147-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your patches are almost entirely baseless.

You haven't even made an effort to show a real case, in detail,
where your patches actually fix a bug.  The CMSG case shows
that you didn't even bother to look at the assembly of even
one architecture to see if padding bytes even existed in the
structure, and that furthermore even if they existed that they
would leak out ever.

I don't even buy the "preventative nature" argument for the
address[128] thing.  If a protocol is leaking kernel memory in that
case, it also isn't filling in the address value properly, which is a
bug times two.

I absolutely am not applying these patches, sorry.
