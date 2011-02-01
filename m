Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1BAEzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 23:55:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40826
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825Ab1BAEzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 23:55:18 -0500
Date: Mon, 31 Jan 2011 20:55:53 -0800 (PST)
Message-Id: <20110131.205553.39195952.davem@davemloft.net>
To: weil@mail.berlios.de
Cc: jon.mason@exar.com, ramkrishna.vepa@exar.com, sivakumar.subramani@exar.com,
        sreenivasa.honnur@exar.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vxge: Fix wrong boolean operator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1296253817-7668-1-git-send-email-weil@mail.berlios.de>
References: <1296253817-7668-1-git-send-email-weil@mail.berlios.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weil <weil@mail.berlios.de>
Date: Fri, 28 Jan 2011 23:30:17 +0100

> This error is reported by cppcheck:
> drivers/net/vxge/vxge-config.c:3693: warning: Mutual exclusion over || always evaluates to true. Did you intend to use && instead?
> 
> It looks like cppcheck is correct, so fix this. No test was run.
> 
> Cc: Ramkrishna Vepa <ramkrishna.vepa@exar.com>
> Cc: Sivakumar Subramani <sivakumar.subramani@exar.com>
> Cc: Sreenivasa Honnur <sreenivasa.honnur@exar.com>
> Cc: Jon Mason <jon.mason@exar.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>

Can the VXGE folks please review this patch?

