Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2JWGgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:36:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37343 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2JWGgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:36:49 -0400
Date: Tue, 23 Oct 2012 02:36:47 -0400 (EDT)
Message-Id: <20121023.023647.2164665243829038911.davem@davemloft.net>
To: cardoe@cardoe.com
Cc: kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Goldstein <cardoe@cardoe.com>
Date: Mon, 22 Oct 2012 00:53:57 -0500

> Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
> applications that query network information via udev to identify vlans
> instead of using strrchr().
> 
> Signed-off-by: Doug Goldstein <cardoe@cardoe.com>

You're extremely misguided.  This change, in fact, makes it ten times
harder for such applications to query such devices.

Because now the application has to decide whether it wants to support
EVERY EXISTING SYSTEM OUT THERE or not.  Hundreds of millions of Linux
systems do not provide this attribute.

Applications have to handle the case of not having the 'vlan' device
type available attribute essentially forever.

So providing it in new kernels provides zero value whatsoever.

I'm not applying this patch, sorry.
