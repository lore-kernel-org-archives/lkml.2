Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0LMU1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:27:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33561
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021Ab0LMU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:27:46 -0500
Date: Mon, 13 Dec 2010 12:28:14 -0800 (PST)
Message-Id: <20101213.122814.02268007.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v9 18/20] pch_can: Optimize "if" condition
 in rx/tx processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292221467-8039-18-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-16-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1292221467-8039-17-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1292221467-8039-18-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Mon, 13 Dec 2010 15:24:24 +0900

> For reduce "if" condition, easy to read/understand the code,
> optimize "if" condition in rx/tx processing.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Applied.
