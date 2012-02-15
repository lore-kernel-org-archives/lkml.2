Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2BOTvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:51:53 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59906 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2BOTvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:51:52 -0500
Date: Wed, 15 Feb 2012 14:50:39 -0500 (EST)
Message-Id: <20120215.145039.1816967174435860741.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120215192106.GI4379@tuxdriver.com>
References: <20120215192106.GI4379@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 11:50:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 15 Feb 2012 14:21:06 -0500

> Here are two more fixes intended for 3.3.  One changes the non-error
> return code for a routine in rtlwifi -- it had been masking an error
> condition that could lead to a divide by zero.  The other moves a
> routine inside of a locked critical section to avoid a "BUG: rwlock bad
> magic".
> 
> Please let me know if there are problems!

Pulled.
