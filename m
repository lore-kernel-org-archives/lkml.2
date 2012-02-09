Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2BIB1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:27:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49946 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2BIB1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:27:47 -0500
Date: Wed, 08 Feb 2012 20:27:43 -0500 (EST)
Message-Id: <20120208.202743.1911103749916770081.davem@davemloft.net>
To: hpa@zytor.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 18/21] sparc: Use generic posix_types.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328677745-20121-19-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
	<1328677745-20121-19-git-send-email-hpa@zytor.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 17:27:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue,  7 Feb 2012 21:09:02 -0800

> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Change the sparc architecture to use <asm-generic/posix_types.h>.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Acked-by: David S. Miller <davem@davemloft.net>
