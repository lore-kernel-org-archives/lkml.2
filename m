Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab0FPTE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:04:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45562
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457Ab0FPTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:04:27 -0400
Date: Wed, 16 Jun 2010 12:04:39 -0700 (PDT)
Message-Id: <20100616.120439.104063332.davem@davemloft.net>
To: schwab@redhat.com
Cc: plaes@plaes.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: IMAP through SSH tunnels stopped working in 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3ocfbjle2.fsf@hase.home>
References: <1276683847.3874.25.camel@chi>
	<m3ocfbjle2.fsf@hase.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schwab <schwab@redhat.com>
Date: Wed, 16 Jun 2010 12:56:53 +0200

> Priit Laes <plaes@plaes.org> writes:
> 
>> I recently tried out 2.6.35-rc3 kernel (latest Linus's tree), where I
>> noticed that I couldn't access my IMAP accounts through ssh tunnel
>> anymore because connection timeouts. Things used to work in 2.6.34-rc7+.
> 
> See <https://bugzilla.kernel.org/show_bug.cgi?id=16188>.

Also "linux-netdev" does not exist, it's just plain "netdev" :-)
