Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1KHRPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:15:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51814 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1KHRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:15:34 -0500
Date: Tue, 08 Nov 2011 12:15:26 -0500 (EST)
Message-Id: <20111108.121526.1753608364705399194.davem@davemloft.net>
To: danila.st@mail.ru
Cc: peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: Add IPSec IP Range in Linux kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1RNhE5-0005rf-00.danila-st-mail-ru@f105.mail.ru>
References: <92909814.20111108111036@mail.ru>
	<1320733465.21617.4.camel@ppwaskie-mobl2>
	<E1RNhE5-0005rf-00.danila-st-mail-ru@f105.mail.ru>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 09:15:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniil Stolnikov <danila.st@mail.ru>
Date: Tue, 08 Nov 2011 12:40:13 +0400

> I turned to you, the developers, but rather to urge you to implement
> this feature using IP range.

This won't be implemented, the keys used for IPSEC rule lookups supported by
the kernel are already way too complex.

Ranges can be synthesized by userspace, and that's the way it has to
be supported.
