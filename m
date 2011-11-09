Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1KIBgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:36:25 -0500
Received: from smtp5.mail.ru ([94.100.176.132]:55408 "EHLO smtp5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab1KIBgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:36:23 -0500
Date: Wed, 9 Nov 2011 09:36:07 +0800
From: Daniil Stolnikov <danila.st@mail.ru>
Reply-To: Daniil Stolnikov <danila.st@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1289495586.20111109093607@mail.ru>
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        <linux-crypto@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <davem@davemloft.net>,
        <adobriyan@gmail.com>, <peter.p.waskiewicz.jr@intel.com>
Subject: Re: Add IPSec IP Range in Linux kernel
In-Reply-To: <20111108.121620.2044664919065812135.davem@davemloft.net>
References: <92909814.20111108111036@mail.ru> <1320733465.21617.4.camel@ppwaskie-mobl2> <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com> <20111108.121620.2044664919065812135.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Daniil Stolnikov <danila.st@mail.ru>
> Date: Tue, 08 Nov 2011 12:40:13 +0400

>> I turned to you, the developers, but rather to urge you to implement
>> this feature using IP range.

> This won't be implemented, the keys used for IPSEC rule lookups supported by
> the kernel are already way too complex.

> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Tue, 8 Nov 2011 14:08:24 +0200

>> changing addr_match() is trivial for ipv4 and easy for ipv6. :-)

> No, this is not happening.  This added complexity screws up all the hash table
> and lookup optimizations we have in the XFRM layer.

I never imagined that it will cause some difficulties. Several questions arise:

1) How complex is this implementation?
2) How to do this time?
3) Will this feature is implemented vsetaki? If so, how soon and what will it take?


> Ranges can be synthesized by userspace, and that's the way it has to
> be supported.

That is, you want to say that all this can be done at the user level? How so?

In general, if there are alternative implementations of this feature without support at the kernel level? What are some loopholes, tricks? It is meant to create multiple connections to the same subnet subranges without the use of masks such as / 29. Perhaps this can be achieved through l2tp? There, in the present setup IP range. Or is it both?

