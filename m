Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1JSXbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:31:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51906 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab1JSXba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:31:30 -0400
Date: Wed, 19 Oct 2011 19:31:24 -0400 (EDT)
Message-Id: <20111019.193124.1671539300674527473.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Subject: Re: [PATCH] NET: asix: fix ethtool -e for AX88178 USB dongle
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318866666-956-1-git-send-email-grundler@chromium.org>
References: <1318866666-956-1-git-send-email-grundler@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 16:31:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>
Date: Mon, 17 Oct 2011 08:51:06 -0700

> "ethtool -e ethX" dumps EEPROM data. Patch sets EEPROM length for device.
> Ethtool works alot better when the kernel believes the length is > 0.
> 
> From: Allan Chou <allan@asix.com.tw>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Applied to net-next, thanks.
