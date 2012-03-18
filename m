Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2CROTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 10:19:52 -0400
Received: from mail.us.es ([193.147.175.20]:41210 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab2CROTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 10:19:50 -0400
Date: Sun, 18 Mar 2012 15:19:43 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: kaber@trash.net, davem@davemloft.net, Dave Jones <davej@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: netfilter: Hung task
Message-ID: <20120318141943.GA28850@1984>
References: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 12:55:13PM +0200, Sasha Levin wrote:
> Hi all,
> 
> I got the following spew after fuzzing using trinity on a KVM tools
> guest, using the latest linux-next.
> 
> It reminds me a lot of https://lkml.org/lkml/2012/3/14/375 and
> https://lkml.org/lkml/2012/1/14/45

You mention neither Linux kernel version nor the way you trigger this.

With that little information it's really hard to really know.

Time ago we applied this to Netfilter which is already in mainline:

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=70e9942f17a6193e9172a804e6569a8806633d6b
