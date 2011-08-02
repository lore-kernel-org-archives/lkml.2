Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1HBLWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:22:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1HBLW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:22:29 -0400
Date: Tue, 02 Aug 2011 04:22:16 -0700 (PDT)
Message-Id: <20110802.042216.1555611529250936804.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: rientjes@google.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110802111117.10a73b89@lxorguk.ukuu.org.uk>
References: <20110802101614.009cdf42@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
	<20110802111117.10a73b89@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 02 Aug 2011 04:22:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 2 Aug 2011 11:11:17 +0100

> Perhaps the right way to do it would be to file the bugzillas in the key
> distros instead

I completely disagree, there are lots of distributions and filing a bug
with all of them is unreasonable.  Some don't even have bug databases and
are just a bunch of people maintaining a distribution for fun :-)

So even the most obscure distribution might want to notice this and
fix it if it's users care about it enough to report it.
