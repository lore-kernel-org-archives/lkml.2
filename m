Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1GDUp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:45:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53811 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1GDUp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:45:56 -0400
X-Greylist: delayed 826 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jul 2011 16:45:56 EDT
Date: Mon, 4 Jul 2011 13:45:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, james_p_freyensee@linux.intel.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 4 (misc/pti)
Message-Id: <20110704134541.9adfd4f1.randy.dunlap@oracle.com>
In-Reply-To: <20110704170952.1024e89b.sfr@canb.auug.org.au>
References: <20110704170952.1024e89b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E12267F.00D1:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011 17:09:52 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110701:


when CONFIG_PCI is not enabled:

drivers/misc/pti.c:410: error: implicit declaration of function 'pci_release_region'
drivers/misc/pti.c:859: error: implicit declaration of function 'pci_request_region'


Stubs for these 2 functions could be added to include/linux/pci.h, but it would
make more sense to me just to make the driver depend on PCI since it seems to rely
on so many PCI functions.  or are the PCI pieces optional?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
