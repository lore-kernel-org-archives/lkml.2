Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab0JYTOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:14:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40781
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab0JYTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:14:32 -0400
Date: Mon, 25 Oct 2010 12:14:55 -0700 (PDT)
Message-Id: <20101025.121455.112605816.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, morinaga526@dsn.okisemi.com,
        masa-korg@dsn.okisemi.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix
 build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CC4EC38.2040208@dsn.okisemi.com>
References: <4CC4EC38.2040208@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya <tomoya-linux@dsn.okisemi.com>
Date: Mon, 25 Oct 2010 11:32:24 +0900

> @@ -255,21 +255,21 @@ static void pch_can_set_optmode(struct
> pch_can_priv *priv)

This patch has been corrupted by your email client.
