Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226Ab0KQS6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:58:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46622
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935040Ab0KQS6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:58:13 -0500
Date: Wed, 17 Nov 2010 10:58:37 -0800 (PST)
Message-Id: <20101117.105837.70199643.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/isdn/hisax: Add printf format/argument
 verification and fix fallout
From: David Miller <davem@davemloft.net>
In-Reply-To: <f92d95e7dc0afca09c2d76880b76973e4eafb169.1289451201.git.joe@perches.com>
References: <f92d95e7dc0afca09c2d76880b76973e4eafb169.1289451201.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 10 Nov 2010 20:54:58 -0800

> Add __attribute__((format... to several functins
> Make formats and arguments match.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
