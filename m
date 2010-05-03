Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0ECIAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 04:00:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33962
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab0ECIAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 04:00:09 -0400
Date: Mon, 03 May 2010 01:00:16 -0700 (PDT)
Message-Id: <20100503.010016.113721762.davem@davemloft.net>
To: mst@redhat.com
Cc: arnd@arndb.de, sri@us.ibm.com, eric.dumazet@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       dlstevens@us.ibm.com
Subject: Re: [PATCH] macvtap: add ioctl to modify vnet header size
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100503075511.GA8298@redhat.com>
References: <20100502.233232.66719719.davem@davemloft.net>
	<20100502.233439.77341308.davem@davemloft.net>
	<20100503075511.GA8298@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 3 May 2010 10:55:11 +0300

> On Sun, May 02, 2010 at 11:34:39PM -0700, David Miller wrote:
>> What tree is this supposed to build under?  Certinaly not net-2.6
>> or net-next-2.6
> 
> The reason is it needs to be applied on top of the patch that adds the
> same header to tun that you acked.  I put this in patch description:
>> I plan to merge both patches through vhost tree together
>> with mergeable buffer support. Comments?
> In other words, this will be included in a pull request that I
> intend to send out shortly.

works for me:

Acked-by: David S. Miller <davem@davemloft.net>
