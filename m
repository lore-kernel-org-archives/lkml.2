Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1DFVGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:06:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40629
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab1DFVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:06:19 -0400
Date: Wed, 06 Apr 2011 14:05:43 -0700 (PDT)
Message-Id: <20110406.140543.02286734.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-04-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110406200032.GK11941@tuxdriver.com>
References: <20110406200032.GK11941@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 6 Apr 2011 16:00:33 -0400

> Here is another batch of fixes intended for 2.6.39...
> 
> This includes a fix to avoid receiving duplicate frames in "cooked"
> monitor mode, a mac80211 documentation fix to avoid developer
> confusion, an rt2x00 fix to avoid cancelling some uninitialized work,
> a wl12xx buffer overflow fix, an email address correction for wl12xx
> module info, a zd1211rw regression fix, a zd1211rw WARNING fix,
> and rtlwifi fix to avoid using some uninitialized variables, a fix
> to broaden the iwl600 hardware supported by iwlagn to match what the
> Windows driver is supporting, a b43 fix to allocate properly sized
> receive buffers, and some stuff related to device IDs.
> 
> Please let me know if there are problems!

Pulled, thanks John.
