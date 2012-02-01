Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2BATQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:16:08 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33425 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2BATQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:16:05 -0500
Date: Wed, 01 Feb 2012 14:15:51 -0500 (EST)
Message-Id: <20120201.141551.1696887866364021374.davem@davemloft.net>
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH] mISDN: use memchr_inv
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327674295-3700-8-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
	<1327674295-3700-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:15:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 27 Jan 2012 23:24:55 +0900

> Use memchr_inv to check if the data contains all same bytes.  It is
> faster than looping for each byte.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Applied, thanks.
