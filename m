Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2FGUYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:24:19 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:39837 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752699Ab2FGUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:24:14 -0400
Message-ID: <1339100649.2770.20.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <jasowang@redhat.com>, <netdev@vger.kernel.org>, <rusty@rustcorp.com.au>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <mst@redhat.com>
Date: Thu, 7 Jun 2012 21:24:09 +0100
In-Reply-To: <20120607.130512.219951433412203999.davem@davemloft.net>
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com>
	 <20120607.130512.219951433412203999.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18952.004
X-TM-AS-Result: No--13.061800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:05 -0700, David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Thu, 7 Jun 2012 18:15:06 +0100
> 
> > I would really like to see some sort of convention for presenting
> > per-queue statistics through ethtool.  At the moment we have a complete
> > mess of different formats:
> 
> Indeed.  Probably ${QUEUE_TYPE}-${INDEX}-${STATISTIC} is best.
> With an agreed upon list of queue types such as "rx", "tx", "rxtx"
> etc.

I think we should leave the type names open-ended, as there are other
useful groupings like per-virtual-port.  In that case the separator
should be chosen to allow arbitrary type names without ambiguity.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

