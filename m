Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2EGRpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:45:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49591 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2EGRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:44:58 -0400
Date: Mon, 07 May 2012 13:44:51 -0400 (EDT)
Message-Id: <20120507.134451.951672483281209005.davem@davemloft.net>
To: erwanaliasr1@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tshimizu818@gmail.com
Subject: Re: [PATCH] pch_gbe: Adding read memory barriers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA808E3.1030908@gmail.com>
References: <4FA808E3.1030908@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 10:44:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erwan Velu <erwanaliasr1@gmail.com>
Date: Mon, 07 May 2012 19:39:47 +0200

> Please find attached

First of all, for a patch which is not accepted yet you do not
CC: stable.

Second of all, do not put text in the main body of your email which is
unrelated to the patch and should not end up in the commit message.

Instead, post your patch to the appropriate primary mailing lists,
and if it's accepted it can then be submitted to -stable at some
later time.

Your patch posting email should be composed purely of the commit
log message in the message body, followed by the actual patch.

Otherwise the maintainer that applies your patch has to edit out
all of this other flowery text that is unrelated to the commit
and that makes more work for them.

