Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1BJAp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 19:45:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38244
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab1BJAp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 19:45:56 -0500
Date: Wed, 09 Feb 2011 16:46:31 -0800 (PST)
Message-Id: <20110209.164631.260100329.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] pch_can: fix tseg1/tseg2 setting issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297298399-6250-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297298399-6250-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Thu, 10 Feb 2011 09:39:59 +0900

> Previous patch "[PATCH 1/3] pch_can: fix 800k comms issue" is wrong.
> I should have modified tseg1_min not tseg2_min.
> This patch reverts tseg2_min to 1 and set tseg1_min to 2.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied, thanks.
