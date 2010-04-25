Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab0DYJvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:51:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42968
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab0DYJvi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:51:38 -0400
Date: Sun, 25 Apr 2010 02:51:43 -0700 (PDT)
Message-Id: <20100425.025143.196865359.davem@davemloft.net>
To: xiaosuo@gmail.com
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
       jdike@linux.intel.com
Subject: Re: [RFC][PATCH v4 05/18] Add a function to indicate if device use
 external buffer.
From: David Miller <davem@davemloft.net>
In-Reply-To: <t2g412e6f7f1004250233pbdfe4d8aj7dc0e0a4980d8eb9@mail.gmail.com>
References: <1272187206-18534-4-git-send-email-xiaohui.xin@intel.com>
	<1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
	<t2g412e6f7f1004250233pbdfe4d8aj7dc0e0a4980d8eb9@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 25 Apr 2010 17:33:02 +0800

> On Sun, Apr 25, 2010 at 5:19 PM,  <xiaohui.xin@intel.com> wrote:
>> +static int dev_is_mpassthru(struct net_device *dev)
>> +{
>> +       if (dev && dev->mp_port)
>> +               return 1;
>> +       return 0;
>> +}
>> +
> 
> Please make it a inline function. And you would write it with less
> lines of code.
> 
> return dev && dev->mp_port;

And use "bool" :-)
