Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653Ab2DLUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:09:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41147 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2DLUJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:09:26 -0400
Date: Thu, 12 Apr 2012 16:09:24 -0400 (EDT)
Message-Id: <20120412.160924.1955339981542902073.davem@davemloft.net>
To: shuahkhan@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core: simple_strtoul cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334258893.3022.7.camel@lorien2>
References: <1334258893.3022.7.camel@lorien2>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 13:09:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuahkhan@gmail.com>
Date: Thu, 12 Apr 2012 13:28:13 -0600

> Changed net/core/net-sysfs.c: netdev_store() to use kstrtoul() 
> instead of obsolete simple_strtoul().
> 
>>From 84371b0ed8b277ec8005fd0efbc73165a8bd72b9 Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Thu, 12 Apr 2012 10:36:10 -0600
> Subject: [PATCH] net/core: simple_strtoul cleanup
> 
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>

Applied, thanks.
