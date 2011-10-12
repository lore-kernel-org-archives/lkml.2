Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1JLKIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:08:44 -0400
Received: from ixqw-mail-out.ixiacom.com ([74.217.148.5]:47692 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866Ab1JLKIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:08:43 -0400
Subject: Re: [PATCH] dev: use name hash for dev_seq_ops.
From: Mihai Maruseac <mmaruseac@ixiacom.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: <dbaluta@ixiacom.com>, <mmaruseac@ixiacom.com>,
        Mihai Maruseac <mihai.maruseac@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>,
        "therbert@google.com" <therbert@google.com>,
        "jpirko@redhat.com" <jpirko@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111010225536.6ca5c042@nehalam.linuxnetplumber.net>
References: <1318000849-2531-1-git-send-email-mmaruseac@ixiacom.com>
	 <20111007092445.4f097ed9@nehalam.linuxnetplumber.net>
	 <CAOMsUMLRc5dT4kGyAUMLka2f=jTOCeYt8WEkNZPY+dwkrBhPeQ@mail.gmail.com>
	 <20111010225536.6ca5c042@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 13:08:37 +0300
Message-ID: <1318414117.2231.3.camel@sirius>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 22:55 -0700, Stephen Hemminger wrote:
> If ifindex has been deleted, the code should fall back to delivering
> the next offset. That means for the rare case it would have the old
> behavior of linear searching.  There is similar code already to
> deal with /proc/net/route; it continues from the last address.

We rewrote the patch to use the ifindex. Since we are at the beginning,
the patch was sent in another thread. We'll learn how to properly send
the mail.

-- 
Thanks,
Mihai

