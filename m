Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1BIAhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:37:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40779
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756102Ab1BIAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:36:59 -0500
Date: Tue, 08 Feb 2011 16:37:35 -0800 (PST)
Message-Id: <20110208.163735.35038597.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 2/3] pch_can: fix rmmod issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297157343-3213-2-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1297157343-3213-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Tue,  8 Feb 2011 18:29:02 +0900

> Currently, when rmmod pch_can, kernel failure occurs.
> The cause is pci_iounmap executed before pch_can_reset.
> Thus pci_iounmap moves after pch_can_reset.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied.
