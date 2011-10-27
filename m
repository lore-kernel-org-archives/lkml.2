Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1J0CR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:17:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35087 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1J0CRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:17:25 -0400
Date: Wed, 26 Oct 2011 22:17:19 -0400 (EDT)
Message-Id: <20111026.221719.2216112919297458522.davem@davemloft.net>
To: kernel@teksavvy.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: asix usb network driver: nfg
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EA8B283.3010105@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	<20111026.194045.2019668159403582571.davem@davemloft.net>
	<4EA8B283.3010105@teksavvy.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 26 Oct 2011 19:17:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <kernel@teksavvy.com>
Date: Wed, 26 Oct 2011 21:23:15 -0400

> Any strong advance objections to replacing the in-kernel version
> with a (fixed) vendor open source version?

It need to meet the coding etc. standards for inclusion, last
time I looked at it their driver indeed need a bit of cleaning
up.

It's a sad situation, they started with the upstream driver and
just hacked on it however they pleased in their private copy.
So now we have this huge divergance and no effort on their part
to rectify things.
