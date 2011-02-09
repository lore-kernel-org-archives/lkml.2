Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1BIX5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:57:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34413
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab1BIX5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:57:15 -0500
Date: Wed, 09 Feb 2011 15:57:50 -0800 (PST)
Message-Id: <20110209.155750.48510069.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/3 v2] pch_can: fix 800k comms issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297295776-3735-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297295776-3735-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Thu, 10 Feb 2011 08:56:16 +0900

> Previous patch "[PATCH 1/3] pch_can: fix 800k comms issue" is wrong.
> I should have modified tseg1_min not tseg2_min.
> Please discard previous patch and use this patch.

I can't "discard" the previous patch as it's already pushed upstream
into my GIT tree and therefore cannot be reverted.

You need to send a relative fix-up patch.
