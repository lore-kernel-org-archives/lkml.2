Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab0CPXk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:40:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52531
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab0CPXkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:40:25 -0400
Date: Tue, 16 Mar 2010 16:40:47 -0700 (PDT)
Message-Id: <20100316.164047.00470829.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: joern@dublin.logfs.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       romieu@fr.zoreil.com
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI
 Express devices (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <51f3faa71003161630g69160ea9tc1a2d448682632e5@mail.gmail.com>
References: <51f3faa71003151628g5edc4d7av8916ac76cb337bfe@mail.gmail.com>
	<20100316083501.GA3489@Dublin.logfs.org>
	<51f3faa71003161630g69160ea9tc1a2d448682632e5@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Tue, 16 Mar 2010 17:30:53 -0600

> In the meantime, I don't object to reverting the patch for now unless
> we get this sorted out quickly..

Yes if we can't sort this out soon, that's exactly what we should
do.
