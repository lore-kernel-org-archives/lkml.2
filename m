Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0KSUsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:48:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53790
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206Ab0KSUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:48:12 -0500
Date: Fri, 19 Nov 2010 12:48:37 -0800 (PST)
Message-Id: <20101119.124837.70196623.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 8/17] can: EG20T PCH: Change Copyright and
 module description
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CE60F6E.6090205@dsn.okisemi.com>
References: <4CE60F6E.6090205@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Fri, 19 Nov 2010 14:47:26 +0900

> Currently, Copyright and module description are not formal.
> 
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

This patch is changing more than the copyright and module description.

It is also changing function names, the types of members of pch_can_priv,
etc.

This is pretty careless.

So would you please go over this patch series and make sure that each
patch does what it says, and that the commit message matches the
patch?

Then resubmit the series.

Thank you.
