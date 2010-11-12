Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0KLWFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:05:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43259
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756960Ab0KLWFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:05:48 -0500
Date: Fri, 12 Nov 2010 14:06:13 -0800 (PST)
Message-Id: <20101112.140613.45885023.davem@davemloft.net>
To: rjw@sisk.pl
Cc: daniel.blueman@gmail.com, romieu@fr.zoreil.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] gianfar: Do not call device_set_wakeup_enable() under
 a spinlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <201011092254.19550.rjw@sisk.pl>
References: <AANLkTimf_mVrRPEcj8qBbYw1iYHfWdeKUNS3Kk-dfhTT@mail.gmail.com>
	<201011090030.42693.rjw@sisk.pl>
	<201011092254.19550.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 9 Nov 2010 22:54:19 +0100

> The gianfar driver calls device_set_wakeup_enable() under a spinlock,
> which causes a problem to happen after the recent core power
> management changes, because this function can sleep now.  Fix this
> by moving the device_set_wakeup_enable() call out of the
> spinlock-protected area.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Patch applied, thank you.
