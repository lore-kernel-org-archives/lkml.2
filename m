Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883Ab2KAPEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:04:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60068 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761851Ab2KAPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:03:51 -0400
Date: Thu, 01 Nov 2012 11:03:46 -0400 (EDT)
Message-Id: <20121101.110346.1322437819225403446.davem@davemloft.net>
To: balbi@ti.com
Cc: behanw@converseincode.com, linux-usb@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121101072116.GA32013@arwen.pp.htv.fi>
References: <20121031132838.GQ10998@arwen.pp.htv.fi>
	<509144C0.8000601@converseincode.com>
	<20121101072116.GA32013@arwen.pp.htv.fi>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>
Date: Thu, 1 Nov 2012 09:21:16 +0200

> then we can merge to net tree and handle the conflicts when merging to
> Linus, that'd be fine by me as long as people know how to solve the
> conflict properly ;-)

Like Herbert with the crypto tree, I'm simply not merging this
absolute crap into my networking tree.

These changes are totally not appropriate.
