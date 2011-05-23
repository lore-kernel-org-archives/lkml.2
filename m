Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab1EWT4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:56:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56685 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab1EWT4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:56:36 -0400
Date: Mon, 23 May 2011 15:56:30 -0400 (EDT)
Message-Id: <20110523.155630.1404321441037491870.davem@davemloft.net>
To: joe@perches.com
Cc: justinmattock@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]net:8021q:vlan.c Fix pr_info to read on line in the
 syslog.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306167781.8687.20.camel@Joe-Laptop>
References: <1306166698-2036-1-git-send-email-justinmattock@gmail.com>
	<1306167781.8687.20.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 May 2011 12:56:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 23 May 2011 09:23:01 -0700

> though I think that emitting names on startup isn't necessary and
> this is enough:

Agreed, it's not like Ben and I are Napoleon or anything...
