Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2D3JNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab2D3JNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:13:14 -0400
Date: Mon, 30 Apr 2012 12:12:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: Shirley Ma <mashirle@us.ibm.com>, David Miller <davem@davemloft.net>,
        eric.dumazet@gmail.com, avi@redhat.com, arnd@arndb.de,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: getting host CPU utilization (was Re: [PATCH V7 2/4 net-next]
 skbuff: Add userspace zero-copy buffers in skb)
Message-ID: <20120430091246.GB5414@redhat.com>
References: <1306610588.5180.87.camel@localhost.localdomain>
 <1309189510.21764.1.camel@localhost.localdomain>
 <20110627.155426.51839633424542723.davem@davemloft.net>
 <1309279892.3559.6.camel@localhost.localdomain>
 <4E0A0D34.2070507@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0A0D34.2070507@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 10:19:48AM -0700, Rick Jones wrote:
> one of these days I'll have to find a good way to get accurate
> overall CPU utilization from within a guest and teach netperf about
> it.

I think the cleanest way would be to run another netperf server on the
host.  netperf would get a flag with host address and get cpu
utilization info.

This is what we currently do manually: run mpstat on the host.

Thoughts?

By the way, could you point me to code used by netperf
to measure CPU utilization on Linux? I'd like to figure
out why isn't the result always consistent with e.g. mpstat.

Thanks!

-- 
MST
