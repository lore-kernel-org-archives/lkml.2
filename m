Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab0JZRzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:55:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55639
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045Ab0JZRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:55:22 -0400
Date: Tue, 26 Oct 2010 10:55:45 -0700 (PDT)
Message-Id: <20101026.105545.200376685.davem@davemloft.net>
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
In-Reply-To: <20101026.105206.15244527.davem@davemloft.net>
References: <4CC61B1B.3090602@dsn.okisemi.com>
	<20101026.105206.15244527.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 26 Oct 2010 10:52:06 -0700 (PDT)

> It doesn't in net-next-2.6 and that is what you should be generating
                ^^^^^^^^^^^^
> patches against.

I mean net-2.6 of course.
