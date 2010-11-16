Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0KPUnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:43:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58571
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab0KPUnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:43:01 -0500
Date: Tue, 16 Nov 2010 12:43:25 -0800 (PST)
Message-Id: <20101116.124325.116396459.davem@davemloft.net>
To: wg@grandegger.com
Cc: tomoya-linux@dsn.okisemi.com, andrew.chih.howe.khor@intel.com,
        masa-korg@dsn.okisemi.com, sameo@linux.intel.com,
        margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, joel.clark@intel.com, yong.y.wang@intel.com,
        chripell@fsfe.org, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add
 Flow control/Fix Endianess issue/Separate IF register/Enumerate LEC
 macro/Move MSI processing/Use BIT(X)/Change Message Object index/Add
 prefix PCH_
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CE2EC13.9090707@grandegger.com>
References: <4CE275A4.9010400@dsn.okisemi.com>
	<20101116.091443.226753420.davem@davemloft.net>
	<4CE2EC13.9090707@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Tue, 16 Nov 2010 21:39:47 +0100

> Please take into account that this patch got accepted by accident
> (because the maintainer did not respond properly in time). At that time
> the driver was incomplete, not ready for mainline and did not even work
> properly. Therefore it makes little sense to debug or even bisec these
> changes. Just for that reason I made an exemption and added my
> "Acked-by". Hope you can share my arguments.

You don't put stupid on top of stupid and justify the latter using
the former.
