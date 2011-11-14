Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1KNFeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:34:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1KNFeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:34:22 -0500
Date: Mon, 14 Nov 2011 00:34:19 -0500 (EST)
Message-Id: <20111114.003419.603215617598499123.davem@davemloft.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jcliburn@gmail.com,
        chris.snook@gmail.com
Subject: Re: [PATCH V2 1/6] net/ethernet/atl1c: Disable ASPM on various
 chipsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111114.003048.2051399548192848039.davem@davemloft.net>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
	<1321028064-644-2-git-send-email-mjg@redhat.com>
	<20111114.003048.2051399548192848039.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:34:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm reverting all of these.

You do all of that work to research the inf files and whatnot, then
you don't even build test the patches you submit?

Forget it, for something as potentially fragile as this stuff might
be, I simply cannot trust you if you can't even do due diligence
wrt. the build validation.
