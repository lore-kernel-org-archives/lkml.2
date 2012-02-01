Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2BAHGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:06:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56175 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2BAHGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:06:09 -0500
Date: Wed, 01 Feb 2012 02:06:02 -0500 (EST)
Message-Id: <20120201.020602.131240058939599710.davem@davemloft.net>
To: geunsik.lim@gmail.com
Cc: isdn@linux-pingi.de, lucas.demarchi@profusion.mobi, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Keep kernel coding style rule of hfs-s+/sp source
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328079593-19197-1-git-send-email-geunsik.lim@gmail.com>
References: <1328079593-19197-1-git-send-email-geunsik.lim@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 23:06:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@gmail.com>
Date: Wed,  1 Feb 2012 15:59:53 +0900

> Modified for kernel coding style rule of hfs-s+/sp device driver .
> . reference: ./Documentation/CodingStyle
> 
> ex)
> 60 Don't put multiple statements on a single line unless you have
> 61 something to hide:
> 62
> 63         if (condition) do_this;
> 64           do_something_everytime;
> 
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>

This was probably there to eliminate compiler warnings or avoid the
code being eliminated completely, because the result of the register
read is unused.

Have you verified that neither is the case here?

To be honest I very strongly dislike patches like this.  You're
patching a driver that very few people use, and changes like this can
only risk possible regressions that will be hard to notice and it's
not like people scour over this driver often and thus will be upset by
frequently seeing some minor coding style infraction.

I'm not applying this patch.
