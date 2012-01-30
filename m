Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2A3SDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:03:07 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40307 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab2A3SDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:03:04 -0500
Date: Mon, 30 Jan 2012 13:02:59 -0500 (EST)
Message-Id: <20120130.130259.1190745234966440677.davem@davemloft.net>
To: konrad.wilk@oracle.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression in skge that started around acb42a3 (so past
 v3.3-rc1)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120130175738.GA4002@phenom.dumpdata.com>
References: <20120130155816.GA1400@phenom.dumpdata.com>
	<20120130083843.160ffe5e@nehalam.linuxnetplumber.net>
	<20120130175738.GA4002@phenom.dumpdata.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Jan 2012 10:03:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 30 Jan 2012 12:57:38 -0500

> Ah, so you are saying that the problem above is already fixed in 3.3-rc1.

No he's not saying that, he says somewhere we probably need a fix
"like" the commit he mentioned.

He did not say that commit fixes this bug.

