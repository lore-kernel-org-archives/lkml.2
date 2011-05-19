Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab1ESXVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:21:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50753 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab1ESXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:21:15 -0400
Date: Thu, 19 May 2011 19:20:31 -0400 (EDT)
Message-Id: <20110519.192031.1228869097990755099.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, cotte@de.ibm.com,
        borntraeger@de.ibm.com, linux390@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, xma@us.ibm.com, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, krkumar2@in.ibm.com,
        tahm@linux.vnet.ibm.com, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 00/14] virtio and vhost-net performance enhancements
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 May 2011 16:20:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 20 May 2011 02:10:07 +0300

> Rusty, I think it will be easier to merge vhost and virtio bits in one
> go. Can it all go in through your tree (Dave in the past acked
> sending a very similar patch through you so should not be a problem)?

And in case you want an explicit ack for the net bits:

Acked-by: David S. Miller <davem@davemloft.net>

:-)
