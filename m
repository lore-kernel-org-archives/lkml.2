Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0HIUDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:03:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37072
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336Ab0HIUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:03:10 -0400
Date: Mon, 09 Aug 2010 13:03:29 -0700 (PDT)
Message-Id: <20100809.130329.104046974.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: Fix perf_arch_get_caller_regs().
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100809171440.GB5329@nowhere>
References: <20100808.220450.148531617.davem@davemloft.net>
	<20100809171440.GB5329@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 9 Aug 2010 19:14:42 +0200

> Ok thanks a lot! I have no more access to a Sparc box, so I'm
> sorry I can't anymore test perf and ftrace on this architecture :)

You don't need a sparc box to test the build.
