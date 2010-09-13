Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0IMA2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 20:28:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47906
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab0IMA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 20:28:20 -0400
Date: Sun, 12 Sep 2010 17:28:38 -0700 (PDT)
Message-Id: <20100912.172838.226772027.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, nazard.lkml@gmail.com,
        paulmck@linux.vnet.ibm.com
Subject: Re: [Bug #17131] WARN with 3c905 boomerang NIC
From: David Miller <davem@davemloft.net>
In-Reply-To: <0c5PAlgnPrH.A.t5B.UsRjMB@chimera>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
	<0c5PAlgnPrH.A.t5B.UsRjMB@chimera>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 12 Sep 2010 20:14:27 +0200 (CEST)

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17131
> Subject		: WARN with 3c905 boomerang NIC
> Submitter	: Doug Nazar <nazard.lkml@gmail.com>
> Date		: 2010-08-22 6:35 (22 days old)
> Message-ID	: <4C70C516.5020404@gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=128245894300623&w=2
> Handled-By	: David Miller <davem@davemloft.net>

Paul, could you please get the softirq.c _local_bh_enable_ip() warning
patch referenced in that bugzilla queued up for Linus's tree if you
haven't done so already?  I'm pretty sure I ACK'd it too, thanks :-)
