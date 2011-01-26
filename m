Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1AZTzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:55:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49204
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab1AZTzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:55:46 -0500
Date: Wed, 26 Jan 2011 11:56:21 -0800 (PST)
Message-Id: <20110126.115621.104075131.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-01-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110126184745.GB3084@tuxdriver.com>
References: <20110126184745.GB3084@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 26 Jan 2011 13:47:46 -0500

> Dave,
> 
> Here is a collection of fixes intended for 2.6.38.  There is a
> MAINTAINERS fix for iwlwifi, a fix to avoid disabling .11n on iwl4965, a
> NULL pointer fix for rtlwifi, a powersaving wakeup fix for ath9k, and
> some others.
> 
> Also included is a batch of Bluetooth fixes via Gustavo.  These include
> a fix for an RFCOMM crash, a HCI blacklist leak fix, and a number of other
> simple fixes.
> 
> Please let me know if there are problems!

Pulled, thanks John.
