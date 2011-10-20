Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1JTI4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:56:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44550 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab1JTI4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:56:23 -0400
Date: Thu, 20 Oct 2011 04:54:11 -0400 (EDT)
Message-Id: <20111020.045411.1875503503183541494.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: krkumar2@in.ibm.com, rusty@rustcorp.com.au, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: Clean up set_skb_frag()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319100362.3781.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20111020081727.509.83122.sendpatchset@krkumar2.in.ibm.com>
	<1319100362.3781.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 01:54:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 20 Oct 2011 10:46:02 +0200

> Le jeudi 20 octobre 2011 à 13:47 +0530, Krishna Kumar a écrit :
>> Remove manual initialization in set_skb_frag, and instead
>> use __skb_fill_page_desc() to do the same. Patch tested
>> on net-next.
>> 
>> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
...
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks.
