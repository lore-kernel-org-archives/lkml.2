Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab2D0EEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 00:04:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38177 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2D0EES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 00:04:18 -0400
Date: Fri, 27 Apr 2012 00:04:08 -0400 (EDT)
Message-Id: <20120427.000408.889398727032151984.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mac@melware.de,
        isdn@linux-pingi.de
Subject: Re: [PATCH] isdn/eicon: use standard __init,__exit function markup
From: David Miller <davem@davemloft.net>
In-Reply-To: <201204241556.03516.hartleys@visionengravers.com>
References: <201204241556.03516.hartleys@visionengravers.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Apr 2012 21:04:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Tue, 24 Apr 2012 15:56:03 -0700

> Remove the custom DIVA_{INIT,EXIT}_FUNCTION defines and use
> the standard __init,__exit markup.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
