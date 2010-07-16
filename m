Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431Ab0GPCIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:08:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38798
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935419Ab0GPCIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:08:14 -0400
Date: Thu, 15 Jul 2010 19:08:30 -0700 (PDT)
Message-Id: <20100715.190830.229757509.davem@davemloft.net>
To: andy.shevchenko@gmail.com
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers: isdn: remove custom strtoul()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279197440-6585-2-git-send-email-andy.shevchenko@gmail.com>
References: <1279197440-6585-1-git-send-email-andy.shevchenko@gmail.com>
	<1279197440-6585-2-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 15 Jul 2010 15:37:19 +0300

> In this case we safe to use strict_strtoul().
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Applied.
