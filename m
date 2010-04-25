Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0DYJvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:51:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42975
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064Ab0DYJvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:51:49 -0400
Date: Sun, 25 Apr 2010 02:51:54 -0700 (PDT)
Message-Id: <20100425.025154.152946070.davem@davemloft.net>
To: xiaosuo@gmail.com
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
       jdike@linux.intel.com
Subject: Re: [RFC][PATCH v4 05/18] Add a function to indicate if device use
 external buffer.
From: David Miller <davem@davemloft.net>
In-Reply-To: <t2z412e6f7f1004250235ib1002b3doe604d786dadefaa5@mail.gmail.com>
References: <1272187206-18534-4-git-send-email-xiaohui.xin@intel.com>
	<1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
	<t2z412e6f7f1004250235ib1002b3doe604d786dadefaa5@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 25 Apr 2010 17:35:01 +0800

> On Sun, Apr 25, 2010 at 5:19 PM,  <xiaohui.xin@intel.com> wrote:
>> +static int dev_is_mpassthru(struct net_device *dev)
> 
> bool return value should be better here.

Right.
