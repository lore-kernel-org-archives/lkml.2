Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0LMU0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:26:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33439
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899Ab0LMU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:26:31 -0500
Date: Mon, 13 Dec 2010 12:26:59 -0800 (PST)
Message-Id: <20101213.122659.70189139.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v9 07/20] pch_can: Change functions type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292221467-8039-7-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1292221467-8039-5-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1292221467-8039-6-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1292221467-8039-7-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Mon, 13 Dec 2010 15:24:13 +0900

> Currently, these two functions spec(returned value) is unnatural.
> Thus, change the return value's spec
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied.
