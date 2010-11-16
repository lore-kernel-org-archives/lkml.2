Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0KPROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:14:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40151
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036Ab0KPROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:14:19 -0500
Date: Tue, 16 Nov 2010 09:14:43 -0800 (PST)
Message-Id: <20101116.091443.226753420.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, masa-korg@dsn.okisemi.com,
        margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add
 Flow control/Fix Endianess issue/Separate IF register/Enumerate LEC
 macro/Move MSI processing/Use BIT(X)/Change Message Object index/Add
 prefix PCH_
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CE275A4.9010400@dsn.okisemi.com>
References: <4CE275A4.9010400@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Way too many changes in one patch.

Please post one that fixes the endianness issues.

One that fixes the register interface seperation.

One that adds flow control processing.

etc.

When you combine many tasks into one patch it's impossible
to bisect through your changes to debug problems in order
to figure out which changed introduced a bug.

I am not applying this, and I will not apply your patches
until you split them up properly.

You may think that there is zero value in this, but there
is huge value in it for anyone who tries to debug your
changes in the future.  Right now you are making that a
nearly impossible task.
