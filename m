Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0C3Fdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 01:33:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44083
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996Ab0C3Fdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 01:33:49 -0400
Date: Mon, 29 Mar 2010 22:33:50 -0700 (PDT)
Message-Id: <20100329.223350.155118810.davem@davemloft.net>
To: julia@diku.dk
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/sunsu.c: Correct use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1003291139250.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291139250.21896@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Applied, thanks a lot for fixing this.
