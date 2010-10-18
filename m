Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab0JRWQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:16:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56113
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755444Ab0JRWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:16:46 -0400
Date: Mon, 18 Oct 2010 15:17:08 -0700 (PDT)
Message-Id: <20101018.151708.193712688.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: luca@llucax.com.ar, jon.maloy@ericsson.com,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimKbOreV4Fuyw3TbCrk9aa5yBZQSuRbo3Vdx=Q1@mail.gmail.com>
References: <20101018150422.GV8781@llucax.com.ar>
	<20101018184628.GX8781@llucax.com.ar>
	<AANLkTimKbOreV4Fuyw3TbCrk9aa5yBZQSuRbo3Vdx=Q1@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 18 Oct 2010 16:42:33 -0400

> If you have access to the user space code in question, you can just
> switch behaviour semantics based on the results of a uname call, knowing
> that this change was included in versions since approx last Feb.  There
> is also /proc/version which can be parsed manually if you prefer.

Requiring userspace to check kernel versioning information in order
to user an exported userspace API correctly is _ALWAYS_ _WRONG_.

You cannot and must not make backwards incompatible changes to
userspace interfaces.

Really, you can't.
