Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1KHRQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:16:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51828 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1KHRQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:16:28 -0500
Date: Tue, 08 Nov 2011 12:16:20 -0500 (EST)
Message-Id: <20111108.121620.2044664919065812135.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: peter.p.waskiewicz.jr@intel.com, danila.st@mail.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Add IPSec IP Range in Linux kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
References: <92909814.20111108111036@mail.ru>
	<1320733465.21617.4.camel@ppwaskie-mobl2>
	<CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 09:16:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 8 Nov 2011 14:08:24 +0200

> changing addr_match() is trivial for ipv4 and easy for ipv6. :-)

No, this is not happening.  This added complexity screws up all the hash table
and lookup optimizations we have in the XFRM layer.
