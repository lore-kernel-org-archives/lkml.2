Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0CVWfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:35:12 -0400
Received: from waste.org ([173.11.57.241]:44238 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013Ab0CVWfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:35:11 -0400
Subject: Re: [RFC Patch 2/3] bridge: make bridge support netpoll
From: Matt Mackall <mpm@selenic.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20100322082112.4967.5504.sendpatchset@localhost.localdomain>
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>
	 <20100322082112.4967.5504.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 17:35:07 -0500
Message-ID: <1269297307.3552.23.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 04:17 -0400, Amerigo Wang wrote:
> Based on the previous patch, make bridge support netpoll by:
> 
> 1) implement the 4 methods to support netpoll for bridge;
> 
> 2) modify netpoll during forwarding packets in bridge;
> 
> 3) disable netpoll support of bridge when a netpoll-unabled device
>    is added to bridge;

Not sure if this is the right thing to do. Shouldn't we simply enable
polling on all devices that support it and warn about the others (aka
best effort)?

-- 
http://selenic.com : development and support for Mercurial and Linux


