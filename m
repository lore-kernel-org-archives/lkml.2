Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2BHU06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:26:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47385 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2BHU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:26:56 -0500
Date: Wed, 08 Feb 2012 15:26:47 -0500 (EST)
Message-Id: <20120208.152647.2150915591550944292.davem@davemloft.net>
To: pmeerw@pmeerw.net
Cc: linux-kernel@vger.kernel.org, steve.glendinning@smsc.com,
        p.meerwald@bct-electronic.com
Subject: Re: [PATCH 2/2] smsc95xx: allow to re-use MAC address already
 programmed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328699332-9024-2-git-send-email-pmeerw@pmeerw.net>
References: <1328699332-9024-1-git-send-email-pmeerw@pmeerw.net>
	<1328699332-9024-2-git-send-email-pmeerw@pmeerw.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 12:26:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>
Date: Wed,  8 Feb 2012 12:08:52 +0100

> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> 
> patch adds a module parameter which allows to keep the MAC address already 
> set (e.g. by the boot loader) if it is valid (otherwise the MAC address is read 
> from an optional EEPROM or randomly generated)
> 
> tested on beagleboard-xm
> 
> Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>

No way, for the same reason as your other patch.

Module parameters suck, use something generic.
