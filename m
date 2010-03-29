Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0C2WCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:02:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48883
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560Ab0C2WCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:02:52 -0400
Date: Mon, 29 Mar 2010 15:02:53 -0700 (PDT)
Message-Id: <20100329.150253.11262563.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100329212839.GA12254@nowhere>
References: <20100329211149.GK5101@nowhere>
	<20100329.141920.243015356.davem@davemloft.net>
	<20100329212839.GA12254@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 29 Mar 2010 23:28:42 +0200

> It's a Niagara 2 based one.

Strange, that's what I do all of my main sparc64 kernel
work on too.  I've never seen these spurious 'as' crashes.

Hmmmm, what does "ldd /usr/bin/as" give you?

Thanks.
