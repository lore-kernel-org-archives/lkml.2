Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0LaUar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 15:30:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51396
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882Ab0LaUaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 15:30:46 -0500
Date: Fri, 31 Dec 2010 12:31:16 -0800 (PST)
Message-Id: <20101231.123116.229747013.davem@davemloft.net>
To: dsterba@suse.cz
Cc: mcarlson@broadcom.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mchan@broadcom.com
Subject: Re: [PATCH v2] tg3: fix return value check in tg3_read_vpd()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1293630031-27372-1-git-send-email-dsterba@suse.cz>
References: <201012291417.24424.dsterba@suse.cz>
	<1293630031-27372-1-git-send-email-dsterba@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sterba <dsterba@suse.cz>
Date: Wed, 29 Dec 2010 14:40:31 +0100

> Besides -ETIMEDOUT and -EINTR, pci_read_vpd may return other error
> values like -ENODEV or -EINVAL which are ignored due to the buggy
> check, but the data are not read from VPD anyway and this is checked
> subsequently with at most 3 needless loop iterations. This does not
> show up as a runtime bug.
> 
> CC: Matt Carlson <mcarlson@broadcom.com>
> CC: Michael Chan <mchan@broadcom.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>

Applied, thanks.
