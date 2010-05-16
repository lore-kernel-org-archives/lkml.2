Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0EPG2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 02:28:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45684
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab0EPG2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 02:28:40 -0400
Date: Sat, 15 May 2010 23:28:48 -0700 (PDT)
Message-Id: <20100515.232848.137856613.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, opurdila@ixiacom.com, ebiederm@xmission.com,
       eric.dumazet@gmail.com, penguin-kernel@I-love.SAKURA.ne.jp,
       netdev@vger.kernel.org, nhorman@tuxdriver.com, xiaosuo@gmail.com,
       adobriyan@gmail.com
Subject: Re: [Patch v10 0/3] net: reserve ports for applications using
 fixed port numbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100505103033.5600.77502.sendpatchset@localhost.localdomain>
References: <20100505103033.5600.77502.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Wed, 5 May 2010 06:26:34 -0400

> 
> Changes from the previous version:
> - Use 'true' and 'false' for bool's;
> - Fix some coding style problems;
> - Allow appending lines to bitmap proc file so that it will be
>   easier to add new bits.

Applied to net-next-2.6, thanks.
