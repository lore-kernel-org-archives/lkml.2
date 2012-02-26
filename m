Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2BZTld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 14:41:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53641 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2BZTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 14:41:31 -0500
Date: Sun, 26 Feb 2012 14:40:19 -0500 (EST)
Message-Id: <20120226.144019.2044348944862329030.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bluetooth: Remove bogus inline for
 l2cap_chan_connect()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330284719-22348-1-git-send-email-geert@linux-m68k.org>
References: <1330284719-22348-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Feb 2012 11:40:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fix is already in the 'net' GIT tree and will be on it's
way to Linus soon.
