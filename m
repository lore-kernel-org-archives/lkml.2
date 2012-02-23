Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2BWX2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:28:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2BWX2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:28:35 -0500
Date: Thu, 23 Feb 2012 18:28:25 -0500 (EST)
Message-Id: <20120223.182825.1031311733171854243.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com,
        florian@mickler.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: 3.3-rc4+: Reported regressions from 3.2
From: David Miller <davem@davemloft.net>
In-Reply-To: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 23 Feb 2012 15:28:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 23 Feb 2012 23:51:20 +0100 (CET)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42776
> Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2012-02-13 7:45 (11 days old)
> Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2

Potential workaround/fix at:

http://marc.info/?l=linux-kernel&m=132993294018762&w=2
