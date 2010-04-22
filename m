Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0DVFgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:36:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56599
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab0DVFgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:36:16 -0400
Date: Wed, 21 Apr 2010 22:36:20 -0700 (PDT)
Message-Id: <20100421.223620.257172362.davem@davemloft.net>
To: tklein@de.ibm.com
Cc: netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, themann@de.ibm.com
Subject: Re: [PATCH 1/2][RESEND] ehea: error handling improvement
From: David Miller <davem@davemloft.net>
In-Reply-To: <201004211110.55986.tklein@de.ibm.com>
References: <201004211110.55986.tklein@de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Klein <tklein@de.ibm.com>
Date: Wed, 21 Apr 2010 11:10:55 +0200

> Reset a port's resources only if they're actually in an error state
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
> 
> Patch created against net-2.6

I thought you were sorry for wasting my time and that you were going
to follow the directions I gave you last time, and I quote:

--------------------
3) These are not appropriate for net-2.6 as we are deep in
   the -rcX series at this point and only the most diabolical
   bug fixes are appropriate.  Therefore, please generate these
   against net-next-2.6, thanks.
--------------------

And here you are generating your patches against net-2.6.  Heck, you
even feel it's worth mentioning explicitly.

Lucky for you the patches happen to apply cleanly to net-next-2.6 so
I've put them there.
