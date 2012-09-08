Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2IHWZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:25:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35176 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2IHWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:25:07 -0400
Date: Sat, 08 Sep 2012 18:25:04 -0400 (EDT)
Message-Id: <20120908.182504.1746728709833661358.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [BUG][3.4.10] Conflicts between initializing my USB devices
 and my IDE devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1347142965.4746.11.camel@gandalf.local.home>
References: <1347142965.4746.11.camel@gandalf.local.home>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The IDE layer does not handle shared interrupts properly at all,
and it never will be rearchitected to do so.

This is a well known issue.

Please disable IDE in your configuration and use the PATA drivers
instead, which are able to handle shared interrupts properly.

Thanks.
