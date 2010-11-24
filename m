Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0KXTUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:20:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41608
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab0KXTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:20:16 -0500
Date: Wed, 24 Nov 2010 11:20:42 -0800 (PST)
Message-Id: <20101124.112042.179943893.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        akpm@linux-foundation.org
Subject: Re: [PATCH] isdn: icn: Fix stack overflow bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290573987.30543.462.camel@gandalf.stny.rr.com>
References: <1290573578.30543.461.camel@gandalf.stny.rr.com>
	<1290573987.30543.462.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 23 Nov 2010 23:46:27 -0500

> 
> Note, the subject should really be:
> 
> [PATCH] isdn: icn: Fix stack corruption bug.

Applied.

Please CC: isdn patches to netdev@vger.kernel.org in the future as per
"ISDN SUBSYSTEM" in MAINTAINERS.  Patches sent only to the ISDN list
and Karsten are likely to not get looked at for weeks if not longer.

Also, printing out the driver version is not only a waste of text and
data, it's unnecessary (MODULE_VERSION).  So it should be killed off
at some point.

