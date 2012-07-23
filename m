Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2GWUIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:08:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48955 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2GWUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:08:36 -0400
Date: Mon, 23 Jul 2012 13:08:35 -0700 (PDT)
Message-Id: <20120723.130835.1217772163295796220.davem@davemloft.net>
To: bas@bmail.ru
Cc: linux-kernel@vger.kernel.org, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] USB: plusb: Add support for PL-2501
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.02.1207231540580.1183@bas>
References: <alpine.LNX.2.02.1207231540580.1183@bas>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: kyak <bas@bmail.ru>
Date: Mon, 23 Jul 2012 15:44:11 +0400 (MSK)

> From: Mikhail Peselnik <peselnik@gmail.com>
> 
> This patch adds support for PL-2501 by adding the appropriate USB
> ID's. This chip is used in several USB 'Easy Trasfer' Cables.
> 
> Signed-off-by: Mikhail Peselnik <peselnik@gmail.com>
> Tested-by: Mikhail Peselnik <peselnik@gmail.com>

This does not apply cleanly to my net-next tree at all.
