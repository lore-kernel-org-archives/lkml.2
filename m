Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1G2RPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:15:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60606 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1G2RPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:15:35 -0400
Date: Fri, 29 Jul 2011 10:15:15 -0700 (PDT)
Message-Id: <20110729.101515.1435434309123620862.davem@davemloft.net>
To: vitalivanov@gmail.com
Cc: Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xprt.c: htmldocs warning correction
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311959479.2242.41.camel@vivanov>
References: <1311959479.2242.41.camel@vivanov>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 29 Jul 2011 10:15:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Fri, 29 Jul 2011 20:11:19 +0300

> Add description for parameter 'xprt'.
> 
> Warning(/net/sunrpc/xprt.c:196): No description found for parameter 'xprt'
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

There is already a fix for this from Randy Dunlap in my networking
GIT tree.
