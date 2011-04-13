Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1DMRrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:47:11 -0400
Received: from cet.com.ru ([195.178.208.66]:42146 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751138Ab1DMRrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:47:08 -0400
Date: Wed, 13 Apr 2011 21:47:02 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System crash, bisect points to "connector: convert to
 synchronous netlink message processing"
Message-ID: <20110413174702.GB10954@ioremap.net>
References: <BANLkTin5kWej_pThqBvL7dypVB_JGYU7=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin5kWej_pThqBvL7dypVB_JGYU7=A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Apr 13, 2011 at 10:25:39AM -0700, Venkatesh Pallipadi (venki@google.com) wrote:
> I started seeing crashes with linus git recently. The failure
> signature is something like:
> 
> System boots up fine. But, almost immediately crashes. If I am lucky
> enough to  connect to system at right time (after boot and before
> crash) I get something like this before system panic reboots. (I am
> sorry, but, I don't have a console onto this system)

It is already fixed in network tree, thank you.

-- 
	Evgeniy Polyakov
