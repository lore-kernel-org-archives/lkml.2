Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab0J1VlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:41:01 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35775 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101Ab0J1Vkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:40:55 -0400
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
From: Shirley Ma <mashirle@us.ibm.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288299878.30131.2.camel@sridhar.beaverton.ibm.com>
References: <1288216693.17571.38.camel@localhost.localdomain>
	 <1288240804.14342.1.camel@localhost.localdomain>
	 <20101028052021.GD5599@redhat.com>
	 <1288294355.11251.20.camel@localhost.localdomain>
	 <1288296835.11251.24.camel@localhost.localdomain>
	 <1288299878.30131.2.camel@sridhar.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 14:40:50 -0700
Message-ID: <1288302050.11251.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 14:04 -0700, Sridhar Samudrala wrote:
> It would be some change in virtio-net driver that may have improved
> the
> latency of small messages which in turn would have reduced the
> bandwidth
> as TCP could not accumulate and send large packets.

I will check out any latency improvement patch in virtio_net. If that's
the case, whether it is good to have some tunable parameter to benefit
both BW and latency workload?

Shirley 

