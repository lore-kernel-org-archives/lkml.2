Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0JKSL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:11:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47173
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828Ab0JKSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:11:57 -0400
Date: Mon, 11 Oct 2010 11:12:18 -0700 (PDT)
Message-Id: <20101011.111218.112596606.davem@davemloft.net>
To: inaky.perez-gonzalez@intel.com
Cc: jslaby@suse.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, linux-wimax@intel.com
Subject: Re: [PATCH 3/3] NET: wimax, fix use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1286815606.21592.11.camel@localhost.localdomain>
References: <1286789218-13976-1-git-send-email-jslaby@suse.cz>
	<1286789218-13976-3-git-send-email-jslaby@suse.cz>
	<1286815606.21592.11.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Date: Mon, 11 Oct 2010 09:46:46 -0700

> On Mon, 2010-10-11 at 02:26 -0700, Jiri Slaby wrote: 
>> Stanse found that i2400m_rx frees skb, but still uses skb->len even
>> though it has skb_len defined. So use skb_len properly in the code.
>> 
>> And also define it unsinged int rather than size_t to solve
>> compilation warnings.
>> 
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Ops, fail. Thanks for the catch. I assume you have compile tested it.
> 
> Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

Applied.
