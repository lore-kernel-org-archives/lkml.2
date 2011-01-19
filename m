Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1ASWXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:23:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46276
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870Ab1ASWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:23:15 -0500
Date: Wed, 19 Jan 2011 14:23:48 -0800 (PST)
Message-Id: <20110119.142348.186319799.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119222144.GC23544@Krystal>
References: <20110119.134047.232915743.davem@davemloft.net>
	<1295474423.12215.1612.camel@gandalf.stny.rr.com>
	<20110119222144.GC23544@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 17:21:44 -0500

> I still wonder how a 32-bit system can generate an unaligned access trap for an
> access to a 64-bit variable aligned on 32-bit, given that there is, by
> definition, no 64-bit memory accesses available on the architecture ?

Sparc 32-bit (and I believe MIPS 32-bit as well) have such 64-bit
load and store instructions.
