Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2JZGPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:15:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2JZGPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:15:22 -0400
Date: Fri, 26 Oct 2012 02:15:20 -0400 (EDT)
Message-Id: <20121026.021520.955480530231877139.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jean@google.com
Subject: Re: [PATCH v3 net-next] r8169: enable ALDPS for power saving
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121024212003.GA11152@electric-eye.fr.zoreil.com>
References: <1350893153-18320-1-git-send-email-hayeswang@realtek.com>
	<1351059843-1464-1-git-send-email-hayeswang@realtek.com>
	<20121024212003.GA11152@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 24 Oct 2012 23:20:03 +0200

> Hayes Wang <hayeswang@realtek.com> :
>> Enable ALDPS function to save power when link down. Note that the
>> feature should be set after the other PHY settings. And the firmware
>> is necessary. Don't enable it without loading the firmware.
>> 
>> None of the firmware-free chipsets support ALDPS. Neither do the
>> RTL8168d/8111d.
>> 
>> For 8136 series, make sure the ALDPS is disabled before loading the
>> firmware. For 8168 series, the ALDPS would be disabled automatically
>> when loading firmware. You must not disable it directly.
>> 
>> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>

Applied, thanks.
