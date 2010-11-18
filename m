Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab0KRUBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:01:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60273
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759333Ab0KRUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:01:44 -0500
Date: Thu, 18 Nov 2010 12:02:09 -0800 (PST)
Message-Id: <20101118.120209.02273225.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-11-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101118184116.GD2468@tuxdriver.com>
References: <20101118184116.GD2468@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 18 Nov 2010 13:41:16 -0500

> Included is an build fix for b43legacy on ARM, a correction of a
> misnumbered WIPHY_FLAG_* value, a fix for the units passed to
> usb_wait_anchor_empty_timeout in carl9170, a relocation of ath9k's
> pm_qos request to avoid a warning about an unknown object, some device
> ID stuff for ath9k_htc, a corrected eeprom offset for AR9287 devices, a
> regulatory fix for extension channels, a fix on top of the regulatory
> fix that restores HT40 functionality, and an ath9k_htc fix for non-QoS
> frame handling that avoids "severe data loss with some APs".
> 
> Please let me know if there are problems!

Pulled, thanks John.
