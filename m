Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445Ab0GPCI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:08:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38806
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935419Ab0GPCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:08:23 -0400
Date: Thu, 15 Jul 2010 19:08:38 -0700 (PDT)
Message-Id: <20100715.190838.35048648.davem@davemloft.net>
To: andy.shevchenko@gmail.com
Cc: linux-kernel@vger.kernel.org, hjlipp@web.de, tilman@imap.cc,
        isdn@linux-pingi.de, gigaset307x-common@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers: isdn: get rid of custom strtoul()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279197440-6585-3-git-send-email-andy.shevchenko@gmail.com>
References: <1279197440-6585-1-git-send-email-andy.shevchenko@gmail.com>
	<1279197440-6585-3-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 15 Jul 2010 15:37:20 +0300

> There were two methods isdn_gethex() and isdn_getnum() which are custom
> implementations of strtoul(). Get rid of them in regard to
> strict_strtoul() kernel's function.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Applied.
