Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1DLLEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:04:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51470 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890Ab1DLLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:04:07 -0400
Message-Id: <1302606246.21782.1440195277@webmail.messagingengine.com>
X-Sasl-Enc: wYh2VAKKSBHw0a27RX8K7Gvdzboea9yGUBARm/5tifY7 1302606246
From: "Adam McLaurin" <lkml@irotas.net>
To: "Will Newton" <will.newton@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <BANLkTi=jpdLRc35DkBhLmUr8-P+ggcrgoA@mail.gmail.com>
References: <1302575869.13492.1440076201@webmail.messagingengine.com>
 <BANLkTi=jpdLRc35DkBhLmUr8-P+ggcrgoA@mail.gmail.com>
Subject: Re: Loopback and Nagle's algorithm
Date: Tue, 12 Apr 2011 07:04:06 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 10:45 +0100, "Will Newton" <will.newton@gmail.com>
wrote:
> It may be caused by an increase in context switch rate, as both sender
> and receiver are on the same machine.

I'm not sure that's what's happening, since the box where I'm running
this test has 8 physical CPU's and 32 cores in total.

Thanks,
Adam
