Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1ARASZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:18:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab1ARASY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:18:24 -0500
Date: Mon, 17 Jan 2011 16:18:57 -0800 (PST)
Message-Id: <20110117.161857.35031651.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: R_SPARC_13
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295307243.32152.106.camel@duncow>
References: <1295293581.32152.70.camel@duncow>
	<20110117.130238.245404805.davem@davemloft.net>
	<1295307243.32152.106.camel@duncow>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Mon, 17 Jan 2011 23:34:03 +0000

> However the same R_SPARC_13 also exists in scsi_mod.ko. It exists in the
> original Debian 2.6.37-trunk-sparc64 version and in my current build of
> the same with the 8 byte alignment for _trace_events.
 ...

Thanks for the info Richard, I'll look more deeply into this.
