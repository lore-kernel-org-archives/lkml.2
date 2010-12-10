Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0LJUfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:35:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33622
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095Ab0LJUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:35:40 -0500
Date: Fri, 10 Dec 2010 12:36:07 -0800 (PST)
Message-Id: <20101210.123607.35053296.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v16 02/17]Add a new struct for device to manipulate
 external buffer.
From: David Miller <davem@davemloft.net>
In-Reply-To: <38fbf05a450b34e939aa1b0f3a5126711990f0cc.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
	<fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
	<38fbf05a450b34e939aa1b0f3a5126711990f0cc.1291187695.git.xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Wed,  1 Dec 2010 16:08:13 +0800

> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
>     Add a structure in structure net_device, the new field is
>     named as mp_port. It's for mediate passthru (zero-copy).
>     It contains the capability for the net device driver,
>     a socket, and an external buffer creator, external means
>     skb buffer belongs to the device may not be allocated from
>     kernel space.
> 
>     Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
>     Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
>     Reviewed-by: Jeff Dike <jdike@linux.intel.com>

Please eliminate whatever is causing this indentation of your
commit messages.

There should be no special indentation of the commit message.
