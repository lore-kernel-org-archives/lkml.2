Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0C2JO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:14:27 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:61021 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab0C2JOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:14:25 -0400
Date: Mon, 29 Mar 2010 12:12:41 +0300
From: Ozgur Yuksel <ozgur.yuksel@oracle.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel
 paging request - comm: pccardd
Message-ID: <20100329091241.GA3237@oracle.com>
References: <bug-15621-10286@https.bugzilla.kernel.org/>
 <20100324071229.5c42e213.akpm@linux-foundation.org>
 <201003251051.40453.bjorn.helgaas@hp.com>
 <20100325170138.GA5424@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325170138.GA5424@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BB06F0F.00ED:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, Mar 25, 2010 at 06:01:38PM +0100 was the time for Dominik Brodowski to speak thus:
> 
> On Thu, Mar 25, 2010 at 10:51:39AM -0600, Bjorn Helgaas wrote:
> > > It looks like the iomem_resource tree got wrecked.  Has anyone been
> > > changing anything in there lately?
> > 
> > My pci=use_crs patches change the contents of the iomem_resource tree,
> > and it's possible they broke some assumptions PCMCIA was making, so
> > you might see if "pci=nocrs" makes any difference.  If it does, please
> > attach an acpidump and the entire dmesg logs with and without that option.
> 
> ... and /proc/iomem as well as /proc/ioports , please.
Using pci=nocrs workarounds the problem. For data collection, since the boot
does not complete without the w/a - only dmesg is available. 

With pci=nocrs, accessing /proc/iomem gets killed by kernel for some reason.

/proc/iomem /proc/ioports and acpidump are provided for 2.6.31-20-generic-pae
kernel for convenience / comparison.
