Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0EFCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:05:36 -0400
Received: from waste.org ([173.11.57.241]:39698 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0EFCFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:05:34 -0400
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: Matt Mackall <mpm@selenic.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Jeff Moyer <jmoyer@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 21:05:30 -0500
Message-ID: <1273111530.21962.2753.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 04:11 -0400, Amerigo Wang wrote:
> V5:
> Fix coding style problems pointed by David.

Aside from my concern about the policy of disabling netpoll on
bridges/bonds with only partial netpoll support, I don't have any
remaining issues with this. But I'll leave it to other folks to ack the
underlying driver bits for this series.

-- 
Mathematics is the supreme nostalgia of our time.


