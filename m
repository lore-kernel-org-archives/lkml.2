Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0CWE6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:58:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44074
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab0CWE57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:57:59 -0400
Date: Mon, 22 Mar 2010 21:58:22 -0700 (PDT)
Message-Id: <20100322.215822.123414773.davem@davemloft.net>
To: amwang@redhat.com
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, shemminger@linux-foundation.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com,
       jmoyer@redhat.com
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA847EB.9040808@redhat.com>
References: <4BA823D7.4010106@redhat.com>
	<20100322.204939.146100390.davem@davemloft.net>
	<4BA847EB.9040808@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Tue, 23 Mar 2010 12:47:39 +0800

> Yeah, for bonding case, probably. But for bridge case, I think
> we still need to check all, right?

Why?  Who cares?

If it goes out one port and reaches it's destination
the objective has been achieved.

Sending it out N more times achieves nothing.
