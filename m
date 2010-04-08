Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab0DHEBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:01:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37157
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab0DHEBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:01:48 -0400
Date: Wed, 07 Apr 2010 21:01:51 -0700 (PDT)
Message-Id: <20100407.210151.45077626.davem@davemloft.net>
To: mst@redhat.com
Cc: rusty@rustcorp.com.au, jpirko@redhat.com, xma@us.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] virtio-net: move sg off stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100404130741.GA7500@redhat.com>
References: <20100404130741.GA7500@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 4 Apr 2010 16:07:41 +0300

> Move sg structure off stack and into virtnet_info structure.
> This helps remove extra sg_init_table calls as well as reduce
> stack usage.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Michael S. Tsirkin <mst@redhat.com>

Applied to net-next-2.6, thanks Michael.
