Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0EPH2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:28:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41502
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501Ab0EPH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:28:10 -0400
Date: Sun, 16 May 2010 00:28:18 -0700 (PDT)
Message-Id: <20100516.002818.133869940.davem@davemloft.net>
To: bryan.wu@canonical.com
Cc: s.hauer@pengutronix.de, gerg@uclinux.org, amit.kucheria@canonical.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] netdev/fec: fix performance impact from mdio poll
 operation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273199239-11057-2-git-send-email-bryan.wu@canonical.com>
References: <1273199239-11057-1-git-send-email-bryan.wu@canonical.com>
	<1273199239-11057-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri,  7 May 2010 10:27:18 +0800

> BugLink: http://bugs.launchpad.net/bugs/546649
> BugLink: http://bugs.launchpad.net/bugs/457878
> 
> After introducing phylib supporting, users experienced performace drop. That is
> because of the mdio polling operation of phylib. Use msleep to replace the busy
> waiting cpu_relax() and remove the warning message.
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> Acked-by: Andy Whitcroft <apw@canonical.com>

As you've already been told, making these MDIO interfaces fail silently
is not acceptable.

Please fix this bug properly and resubmit this patch series.

Thanks.
