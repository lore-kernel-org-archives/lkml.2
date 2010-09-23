Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0IWTnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:43:18 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:15405 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab0IWTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:43:17 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 15:43:17 EDT
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAP9Im0yrR7H+/2dsb2JhbACDHJ8YcatCigiSS4Eigy1zBIROhWo
X-IronPort-AV: E=Sophos;i="4.57,224,1283731200"; 
   d="scan'208";a="239851083"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level PCI drivers
Date: Thu, 23 Sep 2010 12:33:52 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1285246681.6715.11.camel@morgan.silverblock.net>
In-Reply-To: <1285246681.6715.11.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009231233.52541.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 23, 2010 05:58:01 am Andy Walls wrote:

> Hi Tom,
> 
> pci_iomap() can possibly return NULL here and also in
> vfio_mem_readwrite().  Even if there are no security implications
> (unintended access to low I/O ports?), I think you still have potential
> for an Oops in the code below.
> 
> ... unless there's a reason why pci_iomap() can't possibly return NULL
> in these instances.  Maybe I'm missing something.
> 
> Regards,
> Andy

Thanks for the catch.
