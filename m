Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0EFHow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:44:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48817
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab0EFHou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:44:50 -0400
Date: Thu, 06 May 2010 00:44:57 -0700 (PDT)
Message-Id: <20100506.004457.71584133.davem@davemloft.net>
To: mpm@selenic.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273111530.21962.2753.camel@calx>
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>
	<1273111530.21962.2753.camel@calx>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Wed, 05 May 2010 21:05:30 -0500

> On Wed, 2010-05-05 at 04:11 -0400, Amerigo Wang wrote:
>> V5:
>> Fix coding style problems pointed by David.
> 
> Aside from my concern about the policy of disabling netpoll on
> bridges/bonds with only partial netpoll support, I don't have any
> remaining issues with this. But I'll leave it to other folks to ack the
> underlying driver bits for this series.

Yes the partial support handling is a thorny issue.

But this patch set makes things better than they were before, because
support over such devices didn't work at all previously.

So I'll toss these patches into net-next-2.6, thanks everyone!
