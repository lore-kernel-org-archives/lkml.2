Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0GJVdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:33:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59220
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab0GJVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:33:14 -0400
Date: Sat, 10 Jul 2010 14:33:29 -0700 (PDT)
Message-Id: <20100710.143329.28809304.davem@davemloft.net>
To: zr.public@gmail.com
Cc: isdn@linux-pingi.de, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: isdn: Fixed warnings and odd code.
From: David Miller <davem@davemloft.net>
In-Reply-To: <c40325e3d4cdc2f8c196b57c8581a0656828187c.1278796499.git.zr.public@gmail.com>
References: <c40325e3d4cdc2f8c196b57c8581a0656828187c.1278796499.git.zr.public@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Richey <zr.public@gmail.com>
Date: Sat, 10 Jul 2010 17:27:29 -0400

> @@ -484,27 +484,18 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
>  	 */
>  	outb(PRI_BASEPG_VAL, pgport);
>  	msleep_interruptible(1000);
> -	sig = readl(rambase + SIG_OFFSET);
> +	sig = readl(&rambase + SIG_OFFSET);

There is no way this is correct.
