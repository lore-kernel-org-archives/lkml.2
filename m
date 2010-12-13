Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0LMU0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:26:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33395
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479Ab0LMU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:26:03 -0500
Date: Mon, 13 Dec 2010 12:26:30 -0800 (PST)
Message-Id: <20101213.122630.28821053.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v9 03/20] pch_can: Fix endianness issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1292221467-8039-2-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1292221467-8039-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Mon, 13 Dec 2010 15:24:09 +0900

> there is endianness issue both Tx and Rx.
> Currently, data is set like below.
> Register:
> MSB--LSB
> x x D0 D1
> x x D2 D3
> x x D4 D5
> x x D6 D7
> 
> But Data to be sent must be set like below.
> Register:
> MSB--LSB
> x x D1 D0
> x x D3 D2
> x x D5 D4
> x x D7 D6  (x means reserved area.)
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied.
