Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab2FFUiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:38:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33559 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab2FFUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:38:07 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <1339014259.26966.70.camel@edumazet-glaptop>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
	 <20120606081432.6b602065@nehalam.linuxnetplumber.net>
	 <20120606185107.GA20503@redhat.com>
	 <1339012441.26966.48.camel@edumazet-glaptop>
	 <20120606195814.GA20677@redhat.com>
	 <1339013289.26966.62.camel@edumazet-glaptop>
	 <20120606201620.GA23358@redhat.com>
	 <1339014259.26966.70.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 22:38:03 +0200
Message-ID: <1339015083.26966.74.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 22:24 +0200, Eric Dumazet wrote:

> (ndo_get_stats64() is not allowed to sleep, and I cant see how you are
> going to disable napi without sleeping)
> 
> 

In case you wonder, take a look at bond_get_stats() in
drivers/net/bonding/bond_main.c



