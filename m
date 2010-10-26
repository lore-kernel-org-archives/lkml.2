Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0JZP0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:26:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39684
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076Ab0JZP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:26:14 -0400
Date: Tue, 26 Oct 2010 08:26:37 -0700 (PDT)
Message-Id: <20101026.082637.193705328.davem@davemloft.net>
To: elvis.dowson@mac.com
Cc: linux-kernel@vger.kernel.org, luciano.coelho@nokia.com
Subject: Re: #ifdef CONFIG_ checks not working
From: David Miller <davem@davemloft.net>
In-Reply-To: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
References: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elvis Dowson <elvis.dowson@mac.com>
Date: Tue, 26 Oct 2010 18:28:22 +0400

> #ifdef CONFIG_WL1271
>     printk(KERN_INFO "%s: CONFIG_WL1271 detected\n", __func__);
> #else
>     printk(KERN_INFO "%s: CONFIG_WL1271 not detected\n", __func__);
> #endif

If you set WL1271=m then CONFIG_WL1271_MODULE will be set, not
CONFIG_WL1271.

The latter will only be set if you enable the option with "y".
