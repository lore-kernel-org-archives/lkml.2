Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2BXWu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:50:56 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2BXWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:50:55 -0500
Date: Fri, 24 Feb 2012 17:50:51 -0500 (EST)
Message-Id: <20120224.175051.1564143307942470904.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: benve@cisco.com, roprabhu@cisco.com, neepatel@cisco.com,
        nistrive@cisco.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] enic: Fix endianness bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330102599-1245-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330102599-1245-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 14:50:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Fri, 24 Feb 2012 22:26:39 +0530

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Sparse complaints the endian bug.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

I'll apply this, thanks.
