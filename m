Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab0KQU2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:28:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935525Ab0KQU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:28:48 -0500
Date: Wed, 17 Nov 2010 12:29:12 -0800 (PST)
Message-Id: <20101117.122912.27795111.davem@davemloft.net>
To: joe@perches.com
Cc: trivial@kernel.org, wg@grandegger.com, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] drivers/net/can/sja1000: Use printf extension
 %pR for struct resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <199bf35f52ea48bef79d4b40b504b0c85dca6fad.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
	<199bf35f52ea48bef79d4b40b504b0c85dca6fad.1289597644.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 12 Nov 2010 13:37:59 -0800

> Using %pR standardizes the struct resource output.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
