Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0KKGPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:15:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38687
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab0KKGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:15:38 -0500
Date: Wed, 10 Nov 2010 22:16:02 -0800 (PST)
Message-Id: <20101110.221602.112602821.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-11-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101110185843.GC2714@tuxdriver.com>
References: <20101110185843.GC2714@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 10 Nov 2010 13:58:43 -0500

> Here is a batch of fixes intended for 2.6.37.  Also mixed-in are a few
> device ID updates.  I think the changelog entries are reasonably
> documentary of the issues being fixed, so I won't belabor them. ;-)
> 
> This also includes a round of Bluetooth fixes from Gustavo:
> 
> "The following batch contains some bugfixes for 2.6.37. A fix for unaligned
> access in L2CAP, a Kconfig error, two fixes related to security of
> the Bluetooth links, and support for the a MacBook Air Bluetooth device.
> There is also a one line patch from Matthew Garret, that enables USB
> autosuspend for btusb module, which shall be completely safe. Please
> pull, thanks."

Pulled, thanks.
