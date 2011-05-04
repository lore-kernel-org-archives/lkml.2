Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1EDTl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:41:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52392
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab1EDTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:41:25 -0400
Date: Wed, 04 May 2011 12:40:53 -0700 (PDT)
Message-Id: <20110504.124053.260068550.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: Valdis.Kletnieks@vt.edu, rdunlap@xenotime.net, lkml@techboom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Divide error in bictcp_cong_avoid ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110504123738.7bb4d1ee@nehalam>
References: <20110504113351.4643a0c9@nehalam>
	<16668.1304537481@localhost>
	<20110504123738.7bb4d1ee@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 4 May 2011 12:37:38 -0700

> Don't use BIC, it is known to be unfair between flows.

That doesn't fix the user's bug, nothing in the kernel should causes
crashes under normal circumstances.

Please stop with this deflecting on this report and instead try to
figure out why the illegal divide happens.

Thanks.
