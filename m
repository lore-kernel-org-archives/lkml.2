Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1BIAhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:37:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40785
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756102Ab1BIAhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:37:05 -0500
Date: Tue, 08 Feb 2011 16:37:41 -0800 (PST)
Message-Id: <20110208.163741.15244146.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 3/3] pch_can: fix module reload issue with MSI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297157343-3213-3-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	<1297157343-3213-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Tue,  8 Feb 2011 18:29:03 +0900

> Currently, in case reload pch_can,
> pch_can not to be able to catch interrupt.
> 
> The cause is bus-master is not set in pch_can.
> Thus, add enabling bus-master processing.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied.
