Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab2JWRLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:11:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab2JWRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:11:42 -0400
Date: Tue, 23 Oct 2012 13:11:39 -0400 (EDT)
Message-Id: <20121023.131139.1916916979369476334.davem@davemloft.net>
To: kay@vrfy.org
Cc: cardoe@cardoe.com, kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPXgP10EhtdCT5Bus2+Prfrk0LU3tEeBJq8qq4hK4k=TdiS5qQ@mail.gmail.com>
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
	<20121023.023647.2164665243829038911.davem@davemloft.net>
	<CAPXgP10EhtdCT5Bus2+Prfrk0LU3tEeBJq8qq4hK4k=TdiS5qQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Date: Tue, 23 Oct 2012 12:34:11 +0200

> On Tue, Oct 23, 2012 at 8:36 AM, David Miller <davem@davemloft.net> wrote:
>> From: Doug Goldstein <cardoe@cardoe.com>
>> Date: Mon, 22 Oct 2012 00:53:57 -0500
>>
>>> Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
>>> applications that query network information via udev to identify vlans
>>> instead of using strrchr().
>>>
>>> Signed-off-by: Doug Goldstein <cardoe@cardoe.com>
>>
>> You're extremely misguided.  This change, in fact, makes it ten times
>> harder for such applications to query such devices.
> 
> That makes not much sense, really. Every new interface would fall into
> that category. At least I can't see any mis-guidance here. The other
> devtypes for the major netif types are not that much older.

Only interfaces which provide a facility available in another way
fall into this category.

Thanks for the scarecrow, but no.
