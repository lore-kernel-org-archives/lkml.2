Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946145Ab2EROOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:14:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40261 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946089Ab2EROOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:14:36 -0400
Date: Fri, 18 May 2012 16:14:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        lenb@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add ACPI and power trace points for laptop overheating
Message-ID: <20120518141429.GO27374@one.firstfloor.org>
References: <1337263737-3541-1-git-send-email-andi@firstfloor.org> <CAJd=RBCwLOxQwfmppxxJjfJzEJ+RSoL4MaE9wKtSrotKe2J56w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBCwLOxQwfmppxxJjfJzEJ+RSoL4MaE9wKtSrotKe2J56w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -73,3 +73,4 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
> >  obj-$(CONFIG_ACPI_IPMI)                += acpi_ipmi.o
> >
> >  obj-$(CONFIG_ACPI_APEI)                += apei/
> > +obj-$(CONFIG_TRACEPOINTS)      += acpi-trace.o
> > \ No newline at end of file
> 
> For what the newline is?

For nothing as make works.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
