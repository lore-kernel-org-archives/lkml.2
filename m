Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1IQTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 15:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab1IQTQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 15:16:27 -0400
Date: Sat, 17 Sep 2011 22:17:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: krkumar2@in.ibm.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        mirq-linux@rere.qmqm.pl, joe@perches.com, shemminger@vyatta.com
Subject: Re: [net-next RFC V2 PATCH 0/5] Multiqueue support in tun/tap
Message-ID: <20110917191709.GA6127@redhat.com>
References: <20110917055639.32666.89940.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110917055639.32666.89940.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 02:02:04PM +0800, Jason Wang wrote:
> A wiki-page was created to narrate the detail design of all parts
> involved in the multi queue implementation:
> http://www.linux-kvm.org/page/Multiqueue and some basic tests result
> could be seen in this page
> http://www.linux-kvm.org/page/Multiqueue-performance-Sep-13. I would
> post the detail numbers in attachment as the reply of this thread.

Does it make sense to test both with and without RPS in guest?

-- 
MST
