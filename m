Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1GGPO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:14:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64675 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GGPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:14:56 -0400
Date: Thu, 7 Jul 2011 08:14:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, james_p_freyensee@linux.intel.com,
        linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for July 4 (misc/pti)
Message-Id: <20110707081441.a4a64e59.randy.dunlap@oracle.com>
In-Reply-To: <20110704134541.9adfd4f1.randy.dunlap@oracle.com>
References: <20110704170952.1024e89b.sfr@canb.auug.org.au>
	<20110704134541.9adfd4f1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E15CD6B.013E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011 13:45:41 -0700 Randy Dunlap wrote:

> On Mon, 4 Jul 2011 17:09:52 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110701:
> 
> 
> when CONFIG_PCI is not enabled:
> 
> drivers/misc/pti.c:410: error: implicit declaration of function 'pci_release_region'
> drivers/misc/pti.c:859: error: implicit declaration of function 'pci_request_region'
> 
> 
> Stubs for these 2 functions could be added to include/linux/pci.h, but it would
> make more sense to me just to make the driver depend on PCI since it seems to rely
> on so many PCI functions.  or are the PCI pieces optional?


ping.  still a problem in linux-next 20110706.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
