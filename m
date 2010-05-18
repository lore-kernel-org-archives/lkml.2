Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0EREIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:08:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46971
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab0EREIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:08:24 -0400
Date: Mon, 17 May 2010 21:08:32 -0700 (PDT)
Message-Id: <20100517.210832.27816606.davem@davemloft.net>
To: mst@redhat.com
Cc: quintela@redhat.com, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com,
       arnd@arndb.de, kvm@vger.kernel.org, virtualization@lists.osdl.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alex.williamson@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH] vhost-net: utilize PUBLISH_USED_IDX feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100518011931.GA21918@redhat.com>
References: <20100518011931.GA21918@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 18 May 2010 04:19:31 +0300

> With PUBLISH_USED_IDX, guest tells us which used entries
> it has consumed. This can be used to reduce the number
> of interrupts: after we write a used entry, if the guest has not yet
> consumed the previous entry, or if the guest has already consumed the
> new entry, we do not need to interrupt.
> This imporves bandwidth by 30% under some workflows.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Rusty, Dave, this patch depends on the patch
> "virtio: put last seen used index into ring itself"
> which is currently destined at Rusty's tree.
> Rusty, if you are taking that one for 2.6.35, please
> take this one as well.
> Dave, any objections?

None:

Acked-by: David S. Miller <davem@davemloft.net>
