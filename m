Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2AVTKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:10:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48823 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2AVTKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:10:13 -0500
Date: Sun, 22 Jan 2012 14:10:06 -0500 (EST)
Message-Id: <20120122.141006.530154674609252253.davem@davemloft.net>
To: maciej.rutecki@gmail.com
Cc: davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: recvmsg sleeping from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <201201220854.59968.maciej.rutecki@gmail.com>
References: <20120113182401.GA25885@redhat.com>
	<201201220854.59968.maciej.rutecki@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Jan 2012 11:10:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Rutecki <maciej.rutecki@gmail.com>
Date: Sun, 22 Jan 2012 08:54:59 +0100

> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=42629
> for your bug report, please add your address to the CC list in there, thanks!

Please don't do this, none of the networking developers use bugzilla,
we keep the discussion and analysis going here on netdev.
