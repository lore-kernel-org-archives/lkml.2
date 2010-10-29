Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab0J2IMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599Ab0J2IMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:12:05 -0400
Date: Fri, 29 Oct 2010 10:11:58 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
Message-ID: <20101029081158.GC22688@redhat.com>
References: <1288216693.17571.38.camel@localhost.localdomain>
 <1288240804.14342.1.camel@localhost.localdomain>
 <20101028052021.GD5599@redhat.com>
 <1288294355.11251.20.camel@localhost.localdomain>
 <1288296835.11251.24.camel@localhost.localdomain>
 <1288299878.30131.2.camel@sridhar.beaverton.ibm.com>
 <1288302050.11251.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288302050.11251.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 02:40:50PM -0700, Shirley Ma wrote:
> On Thu, 2010-10-28 at 14:04 -0700, Sridhar Samudrala wrote:
> > It would be some change in virtio-net driver that may have improved
> > the
> > latency of small messages which in turn would have reduced the
> > bandwidth
> > as TCP could not accumulate and send large packets.
> 
> I will check out any latency improvement patch in virtio_net. If that's
> the case, whether it is good to have some tunable parameter to benefit
> both BW and latency workload?
> 
> Shirley 

No, we need it to work well automatically somehow.

-- 
MST
