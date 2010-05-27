Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab0E0Ufw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:35:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56983
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758722Ab0E0Ufu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:35:50 -0400
Date: Thu, 27 May 2010 13:35:59 -0700 (PDT)
Message-Id: <20100527.133559.193700421.davem@davemloft.net>
To: fbl@sysclose.org
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, mpm@selenic.com,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       gospo@redhat.com, nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100527180545.GA2345@sysclose.org>
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>
	<20100527180545.GA2345@sysclose.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Flavio Leitner <fbl@sysclose.org>
Date: Thu, 27 May 2010 15:05:45 -0300

> I did the following patch to discard the packet if it was IN_NETPOLL
> and the read_lock() fails, so I could go ahead testing it:

This is disgusting, let's just disallow console output from such
locations.  Defer them to a workqueue if their output is so critical.
