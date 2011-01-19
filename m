Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1ASWIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:08:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36705
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972Ab1ASWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:08:44 -0500
Date: Wed, 19 Jan 2011 14:09:17 -0800 (PST)
Message-Id: <20110119.140917.108794140.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295474423.12215.1612.camel@gandalf.stny.rr.com>
References: <20110119153326.GC11022@Krystal>
	<20110119.134047.232915743.davem@davemloft.net>
	<1295474423.12215.1612.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 19 Jan 2011 17:00:23 -0500

> We can add a comment next to these structures specifying this
> dependency, and hopefully it would be updated if we ever do include a
> long long in them.

Yes, I think a huge comment should be placed somewhere and also the
commit message for the final version of this fix should be quite
verbose :-)
