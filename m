Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0IRDIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 23:08:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43693
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008Ab0IRDIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 23:08:06 -0400
Date: Fri, 17 Sep 2010 20:08:24 -0700 (PDT)
Message-Id: <20100917.200824.38076236.davem@davemloft.net>
To: maciej.sosnowski@intel.com
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dca: disable dca on IOAT ver.3.0 multiple-IOH platforms
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100916160217.20315.35536.stgit@linux.site>
References: <20100916160217.20315.35536.stgit@linux.site>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date: Thu, 16 Sep 2010 18:02:26 +0200

> Direct Cache Access is not supported on IOAT ver.3.0 multiple-IOH platforms.
> This patch blocks registering of dca providers when multiple IOH detected with IOAT ver.3.0.
> 
> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Applied, thanks.
