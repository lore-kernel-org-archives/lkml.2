Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab1LPEPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:15:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47038 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1LPEPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:15:36 -0500
Date: Thu, 15 Dec 2011 23:15:17 -0500 (EST)
Message-Id: <20111215.231517.185391590658983405.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: joe@perches.com, linux-kernel@vger.kernel.org, pawel.moll@arm.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool
 (net & drivers/net)
From: David Miller <davem@davemloft.net>
In-Reply-To: <87k45xqvfs.fsf@rustcorp.com.au>
References: <877h1ysenl.fsf@rustcorp.com.au>
	<1323920752.29500.11.camel@joe2Laptop>
	<87k45xqvfs.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Dec 2011 20:15:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 16 Dec 2011 09:44:31 +1030

> Dave, did you want a true/false cleanup too?

Please, this kind of stuff rots forever and not using bool properly
drives me crazy.
