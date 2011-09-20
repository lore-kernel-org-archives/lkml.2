Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1ITSsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:48:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1ITSsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:48:22 -0400
Date: Tue, 20 Sep 2011 14:48:12 -0400 (EDT)
Message-Id: <20110920.144812.2183953543808463400.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: mst@redhat.com, jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] macvtap: fix the uninitialized var using in
 macvtap_alloc_skb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1316516283.3891.27.camel@zakaz.uk.xensource.com>
References: <20110919094830.6272.40503.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
	<20110919095415.GD4501@redhat.com>
	<1316516283.3891.27.camel@zakaz.uk.xensource.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Sep 2011 11:48:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Tue, 20 Sep 2011 11:58:03 +0100

> On Mon, 2011-09-19 at 12:54 +0300, Michael S. Tsirkin wrote:
>> On Mon, Sep 19, 2011 at 05:48:31PM +0800, Jason Wang wrote:
>> > Commit d1b08284 use new frag API but would leave f to be used
>> > uninitialized, this patch fix it.
>> > 
>> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>> 
>> Good catch. Makes absolute sense.
>> 
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Agreed. I like this one better than the one I just sent out so:
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Applied.
