Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1ARWDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:03:43 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50035 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1ARWDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:03:41 -0500
Date: Tue, 18 Jan 2011 14:03:13 -0800
From: Ram Pai <linuxram@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
Subject: Re: [PATCH 1/1 Version 2.0] PCI: allocate essential resources
 before reserving hotplug resources
Message-ID: <20110118220313.GC9274@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <201010081416.57454.bjorn.helgaas@hp.com>
 <20110114181915.GA7476@ram-laptop>
 <20110118213009.GA9281@ram-laptop>
 <201101181446.04412.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101181446.04412.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 02:46:02PM -0700, Bjorn Helgaas wrote:
> On Tuesday, January 18, 2011 02:30:09 pm Ram Pai wrote:
> >         PCI: pre-allocate additional resources to devices
> >         only after successful allocation of essential resources.
> > ...
> 
> When you post a new version, can you please include some text about
> "what changed between v1 and v2"?

Ok. I will next version onwards.

BTW: the earlier version called pci_assign_resource() on resources
that needed no resources, causing the pci_assign_resource()
to return failure. This version fixed that issue.

RP
