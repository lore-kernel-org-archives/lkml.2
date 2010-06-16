Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab0FPSt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:49:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43756
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932615Ab0FPSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:49:57 -0400
Date: Wed, 16 Jun 2010 11:50:08 -0700 (PDT)
Message-Id: <20100616.115008.226776050.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-06-16
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100616182847.GB3138@tuxdriver.com>
References: <20100616182847.GB3138@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 16 Jun 2010 14:28:48 -0400

> Here is another passel of of fixes intended for 2.6.35.  Included are
> some build warning fixes, a PCI identifier, a fix for premature
> IRQs during hostap initialization, a fix for a warning caused by
> failing to cancel a scan watchdog in iwlwifi, a fix for a null
> pointer dereference in iwlwifi, and a fix for a race condition in
> the same driver.  Also included is the MAINTAINERS change for the
> orphaning of the older Intel wireless drivers.  All but the last few
> warning fixes have spent some time in linux-next already.
> 
> Please let me know if there are problems!

The patches removing unused function variables just to kill compile
warnings are not appropriate, _at_ _all_.  They don't fix any real
bug, and they definitely don't fix entries in the regression list do
they?

Kill all of those and resend this pull request.

Thanks.
