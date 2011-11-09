Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1KIBnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:43:03 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56647 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1KIBnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:43:01 -0500
Date: Tue, 08 Nov 2011 20:42:53 -0500 (EST)
Message-Id: <20111108.204253.891598837549584662.davem@davemloft.net>
To: danila.st@mail.ru
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        adobriyan@gmail.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: Add IPSec IP Range in Linux kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289495586.20111109093607@mail.ru>
References: <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com>
	<20111108.121620.2044664919065812135.davem@davemloft.net>
	<1289495586.20111109093607@mail.ru>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 17:42:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniil Stolnikov <danila.st@mail.ru>
Date: Wed, 9 Nov 2011 09:36:07 +0800

> I never imagined that it will cause some difficulties.

Ever feature has side effects and costs associated with it.  Some of
which can be non-trivial.

Like I said, if you want address ranges, ask the userland IPSEC daemon
authors to synthesize it.

I'm really not able to devote the time necessary to explain every
nuance of how we store IPSEC rules in the kernel side database and
what implications that has for expanding the kind of match keys we
support.
