Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2FGUFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:05:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2FGUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:05:14 -0400
Date: Thu, 07 Jun 2012 13:05:12 -0700 (PDT)
Message-Id: <20120607.130512.219951433412203999.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com>
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 7 Jun 2012 18:15:06 +0100

> I would really like to see some sort of convention for presenting
> per-queue statistics through ethtool.  At the moment we have a complete
> mess of different formats:

Indeed.  Probably ${QUEUE_TYPE}-${INDEX}-${STATISTIC} is best.
With an agreed upon list of queue types such as "rx", "tx", "rxtx"
etc.
