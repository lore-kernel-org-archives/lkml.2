Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1FVUXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:23:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1FVUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:23:08 -0400
Date: Wed, 22 Jun 2011 13:23:01 -0700 (PDT)
Message-Id: <20110622.132301.937541188453252019.davem@davemloft.net>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: brcm80211 build busted on big-endian
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110622154022.GB19027@kroah.com>
References: <20110621.193641.1605224831578508501.davem@davemloft.net>
	<20110622154022.GB19027@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Jun 2011 13:23:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 22 Jun 2011 08:40:22 -0700

> For big endian, I agree, which is why I thought I fixed this up so it
> wouldn't build on other arches than MIPS for the moment.
> 
> Is this blowing up in -next or in Linus's tree right now?

Yes, on sparc64.
