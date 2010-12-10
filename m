Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0LJTQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:16:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52545
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126Ab0LJTQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:16:33 -0500
Date: Fri, 10 Dec 2010 11:17:00 -0800 (PST)
Message-Id: <20101210.111700.28826066.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v8 01/20] CAN : Add flow control
 processing.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CFE13E4.2020707@dsn.okisemi.com>
References: <4CFE13E4.2020707@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your subject lines need to be fixed.

You are not making changes to the CAN subsystem, you are making
changes to the "pch_can" device driver.

Also you should not put a space before the ":" character.  So
something like 

[PATCH net-next-2.6 v8 01/20] pch_can: Add flow control processing

Thanks.
