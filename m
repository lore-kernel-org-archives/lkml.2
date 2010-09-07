Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0IGQrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:47:53 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:33055 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab0IGQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:47:45 -0400
Date: Tue, 07 Sep 2010 12:47:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fix typos
In-reply-to: <20100902121853.e90f6c53.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.2.00.1009071236540.22515@localhost.localdomain>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fixes to the ACPI and idle-related files below are correct
and so I'll apply them now - thanks.

drivers/acpi/acpica/exutils.c
drivers/acpi/acpica/rsutils.c
drivers/acpi/apei/Kconfig
drivers/acpi/apei/erst-dbg.c
drivers/acpi/apei/erst.c
drivers/acpi/bus.c
drivers/acpi/processor_perflib.c
include/acpi/acpixf.h

drivers/cpuidle/governors/menu.c

It may be problematic to apply a single jumbo patch to the entire kernel
b/c it will surely conflict with code that is changing.

thanks,
Len Brown, Intel Open Source Technology Center

