Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0LBVNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:13:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50119
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313Ab0LBVNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:13:36 -0500
Date: Thu, 02 Dec 2010 13:14:02 -0800 (PST)
Message-Id: <20101202.131402.102554930.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v6 05/20] can: EG20T PCH: Delete
 unnecessary spin_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CF47B68.4050405@dsn.okisemi.com>
References: <4CF47B68.4050405@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Tue, 30 Nov 2010 13:19:52 +0900

> Delete unnecessary spin_lock for accessing Message Object.
> Since all message objects are divided into tx/rx area completely,
> spin_lock processing is unnecessary.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Applied.
