Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2C2Gtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:49:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35777 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2C2GtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:49:24 -0400
Date: Thu, 29 Mar 2012 02:49:10 -0400 (EDT)
Message-Id: <20120329.024910.1984119977666436533.davem@davemloft.net>
To: marc@merlins.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.2.8/amd64 full interrupt hangs and deadlocks under big
 network copies (page allocation failure)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120329053111.GD24933@merlins.org>
References: <20120311183244.GA14001@merlins.org>
	<20120329053111.GD24933@merlins.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 23:49:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc MERLIN <marc@merlins.org>
Date: Wed, 28 Mar 2012 22:31:11 -0700

> This is a pretty bad failure. Someone please tell me there is
> something I can do to work around the problem, and get the
> underlying problem fixed.

First step would be to report this to the proper mailing list,
most networking and wireless developers do not read linux-kernel.

I'd start with linux-wireless@vger.kernel.org and netdev@vger.kernel.org
