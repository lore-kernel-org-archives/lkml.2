Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1ALVwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:52:53 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:54834 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1ALVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:52:50 -0500
Date: Wed, 12 Jan 2011 16:52:39 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-acpi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: on builds/randconfigs
In-reply-to: <4D2DF526.7090308@oracle.com>
Message-id: <alpine.LFD.2.02.1101121646240.19754@x980>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
 <20101213112033.d0060e6c.randy.dunlap@oracle.com>
 <20110110090059.6f4d739d.randy.dunlap@oracle.com>
 <alpine.LFD.2.02.1101120008590.19140@x980> <4D2DE97C.2000205@oracle.com>
 <alpine.LFD.2.02.1101121257580.18873@x980> <4D2DF526.7090308@oracle.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Who defines useful?

> > Configs that will be used are useful.

> Then I suggest that you start deleting non-useful kernel configs.
> You can begin in ACPI.

Maybe I wasn't clear in my previous note...

Originally, ACPI did not depend on PCI, PNP, or PM.
Now it does.  That is an 8x reduction in phantom configs.

I'm all ears for ideas on further simplification.

-Len

