Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab2K3RXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:23:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44715 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2K3RXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:23:04 -0500
Date: Fri, 30 Nov 2012 12:23:02 -0500 (EST)
Message-Id: <20121130.122302.1825816242500143123.davem@davemloft.net>
To: jkosina@suse.cz
Cc: pt@netconsequence.de, otavio@ossystems.com.br, javier@dowhile0.org,
        chohnstaedt@innominate.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: RFC: Workaround for problems with lan8710 phy
 auto MDI-X
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1211301622110.25639@pobox.suse.cz>
References: <8D7E9026-6276-452B-9E0C-AEB8CF38C9FD@netconsequence.de>
	<alpine.LNX.2.00.1211301622110.25639@pobox.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Fri, 30 Nov 2012 16:23:30 +0100 (CET)

> Of course it'd be far better if faulty hardware can be autodetected in 
> runtime.

That is how this must be handled.
