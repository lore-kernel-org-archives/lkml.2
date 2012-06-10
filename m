Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2FJKWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:22:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab2FJKWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:22:30 -0400
Date: Sun, 10 Jun 2012 13:22:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120610102252.GA6793@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
 <1338972341.2760.3944.camel@edumazet-glaptop>
 <87ipezhdvx.fsf@rustcorp.com.au>
 <20120610070325.GA14010@redhat.com>
 <1339323674.6001.246.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339323674.6001.246.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:21:14PM +0200, Eric Dumazet wrote:
> On Sun, 2012-06-10 at 10:03 +0300, Michael S. Tsirkin wrote:
> 
> > One question though: do we want to lay the structure
> > out so that the rx sync structure precedes the rx counters?
> > 
> 
> I am not sure its worth having holes in the structure, since its percpu
> data.
> 
> That would be 8 bytes lost per cpu and per device.

Right, I forgot it's per cpu.

