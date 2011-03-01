Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab1CAUiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:38:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46698
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483Ab1CAUiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:38:52 -0500
Date: Tue, 01 Mar 2011 12:39:29 -0800 (PST)
Message-Id: <20110301.123929.48508312.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-03-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110301184609.GA2536@tuxdriver.com>
References: <20110301184609.GA2536@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 1 Mar 2011 13:46:10 -0500

> Here is another handful of fixes intended for 2.6.38.  Included are a
> couple of device IDs, a one-liner to allow iwlagn to load a bug-fixed
> firmware for iwl5000, an endian fix for ath9k, another ath9k fix to
> correct a regression involving interrupt enabling, and a fix to disable
> power save mode for BCM4320b in rndis_wlan.
> 
> Please let me know if there are problems!

Pulled, thanks John.
