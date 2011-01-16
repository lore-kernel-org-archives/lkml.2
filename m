Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1APTjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:39:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37668
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754Ab1APTjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:39:11 -0500
Date: Sun, 16 Jan 2011 11:39:44 -0800 (PST)
Message-Id: <20110116.113944.48514452.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295187469.22527.13.camel@duncow>
References: <4D3074FE.3030707@oldelvet.org.uk>
	<20110115.211722.39173519.davem@davemloft.net>
	<1295187469.22527.13.camel@duncow>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Sun, 16 Jan 2011 14:17:49 +0000

> I'm wondering if gcc is just getting better at honouring the source
> code. The DEFINE_EVENT macros in include/trace/ftrace.h have a
> __aligned__(4) attribute in them. Maybe that should be 8 on sparc64
> systems.
> The aligned 4 seems to be unchanged since include/trace/ftrace.h was
> created in f42c85e74faa422cf0bc747ed808681145448f88 in April 2009.

That needs to be at least "8" on 64-bit systems.  Why is this aligned
directive there at all?
