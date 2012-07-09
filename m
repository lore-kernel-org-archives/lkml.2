Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2GIVt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:49:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59544 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2GIVt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:49:27 -0400
Date: Mon, 09 Jul 2012 14:49:26 -0700 (PDT)
Message-Id: <20120709.144926.373399647799528683.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: dilip.daya@hp.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        serge@hallyn.com
Subject: Re: [PATCH 1/2] bonding: Manage /proc/net/bonding/ entries from
 the netdev events
From: David Miller <davem@davemloft.net>
In-Reply-To: <87y5ms3bfi.fsf_-_@xmission.com>
References: <87fw94g1kq.fsf@xmission.com>
	<20120706194741.GA22113@mail.hallyn.com>
	<87y5ms3bfi.fsf_-_@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 Jul 2012 13:51:45 -0700

> 
> It was recently reported that moving a bonding device between network
> namespaces causes warnings from /proc.  It turns out after the move we
> were trying to add and to remove the /proc/net/bonding entries from the
> wrong network namespace.
> 
> Move the bonding /proc registration code into the NETDEV_REGISTER and
> NETDEV_UNREGISTER events where the proc registration and unregistration
> will always happen at the right time.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Applied.
