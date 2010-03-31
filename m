Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab0CaKQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:16:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47177
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933180Ab0CaKQh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:16:37 -0400
Date: Wed, 31 Mar 2010 03:16:36 -0700 (PDT)
Message-Id: <20100331.031636.04083770.davem@davemloft.net>
To: mst@redhat.com
Cc: mashirle@us.ibm.com, thomas@mathtm.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH next-next-2.6 v2] virtio_net: missing sg_init_table
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100331092022.GA31911@redhat.com>
References: <4BB10010.5060505@mathtm.de>
	<1269911955.14013.4.camel@localhost.localdomain>
	<20100331092022.GA31911@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 31 Mar 2010 12:20:22 +0300

> On Mon, Mar 29, 2010 at 06:19:15PM -0700, Shirley Ma wrote:
>> Add missing sg_init_table for sg_set_buf in virtio_net which
>> induced in defer skb patch.
>> 
>> Reported-by: Thomas Müller <thomas@mathtm.de>
>> Tested-by: Thomas Müller <thomas@mathtm.de>
>> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> 
> I'm concerned that the 'big' path might cause a performance regression.
> Let's move sg into virtnet_info so that this needs to be only called
> once?

Yeah that might improve things.

Shirley's change is already in net-next-2.6 so anything implementing
this would need to be submitted relative to that.
