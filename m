Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2GXG5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:57:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53271 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2GXG5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:57:48 -0400
Date: Mon, 23 Jul 2012 23:57:47 -0700 (PDT)
Message-Id: <20120723.235747.618940855187036141.davem@davemloft.net>
To: bas@bmail.ru
Cc: linux-kernel@vger.kernel.org, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] USB: plusb: Add support for PL-2501
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.02.1207240930140.1183@bas>
References: <alpine.LNX.2.02.1207231540580.1183@bas>
	<20120723.130835.1217772163295796220.davem@davemloft.net>
	<alpine.LNX.2.02.1207240930140.1183@bas>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: kyak <bas@bmail.ru>
Date: Tue, 24 Jul 2012 09:39:40 +0400 (MSK)

> This patch was created against linux-3.5, but it applies perfectly
> against net-next tree, i just checked..
> 
> I'm sorry for not being able to submit the correct patch from the
> first attempt (and not even from the third attempt). Could you be more
> specific about "doesn't apply cleanly at all"?

"git am your_patch" fails.

