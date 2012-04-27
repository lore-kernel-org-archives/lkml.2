Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088Ab2D0EET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 00:04:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38176 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2D0EER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 00:04:17 -0400
Date: Fri, 27 Apr 2012 00:04:14 -0400 (EDT)
Message-Id: <20120427.000414.1200447282191234979.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ceph-devel@vger.kernel.org, sage@newdream.net
Subject: Re: [PATCH] crush: include header for global symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <201204241738.38280.hartleys@visionengravers.com>
References: <201204241738.38280.hartleys@visionengravers.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Apr 2012 21:04:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Tue, 24 Apr 2012 17:38:37 -0700

> Include the header to pickup the definitions of the global symbols.
> 
> Quiets the following sparse warnings:
> 
> warning: symbol 'crush_find_rule' was not declared. Should it be static?
> warning: symbol 'crush_do_rule' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
