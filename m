Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966078Ab2B2G2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:28:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53455 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2B2G2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:28:19 -0500
Date: Wed, 29 Feb 2012 01:27:41 -0500 (EST)
Message-Id: <20120229.012741.966942726583313413.davem@davemloft.net>
To: mroos@linux.ee
Cc: sam@ravnborg.org, tj@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1202290814280.23308@math.ut.ee>
References: <alpine.SOC.1.00.1202282333580.3974@math.ut.ee>
	<20120228.175659.40937269571989661.davem@davemloft.net>
	<alpine.SOC.1.00.1202290814280.23308@math.ut.ee>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 22:28:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 29 Feb 2012 08:15:06 +0200 (EET)

> Here it is - triggers this time:

Thanks a lot.

I need to add some more diagnostics to further narrow it down,
I'll give you a patch for that when I get a chance.
