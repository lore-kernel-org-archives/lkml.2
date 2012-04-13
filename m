Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2DMPGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:06:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49603 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2DMPGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:06:09 -0400
Date: Fri, 13 Apr 2012 11:05:52 -0400 (EDT)
Message-Id: <20120413.110552.522790652681369943.davem@davemloft.net>
To: just.for.lkml@googlemail.com
Cc: rick.jones2@hp.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix misplaces parenthesis in virtio_net.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120409171415.4c49c96a@googlemail.com>
References: <20120409171415.4c49c96a@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 08:05:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torsten Kaiser <just.for.lkml@googlemail.com>
Date: Mon, 9 Apr 2012 17:14:15 +0200

> Commit 2e57b79ccef1ff1422fdf45a9b28fe60f8f084f7 misplaced its
> parenthesis and now tx_fifo_errors will only be incremented if an
> ENOMEM error is not written to the syslog.
> 
> Correct the parenthesis and indentation to the original goal of
> counting all non ENOMEM errors and ratelimiting only the messages.
> 
> Signed-of-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Applied, thank you.
