Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab2C2SNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:13:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45993 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634Ab2C2SNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:13:31 -0400
Date: Thu, 29 Mar 2012 14:08:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] RFC: Prepare PAD for native and	xen
 platform
Message-ID: <20120329180842.GA14789@phenom.dumpdata.com>
References: <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
 <20120226173458.GB18098@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350B9496@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350BAC09@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC8292335105EFA@SHSMSX101.ccr.corp.intel.com>
 <20120326164835.GE10236@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233510F52B@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233510F5C5@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233510F5C5@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F74A63C.0014,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> If it benefits other architectures (say ARM) then adding in hooks
> >> there (in osl for example) makes sense - but I am not sure if ARM
> >> has a form of _PUR code/calls it needs to do.
> >> 
> >> So with that in mind, neither of those options seems proper - as all
> >> of them depend on changing something in drivers/acpi/*.
> >> 
> >> I've one or two suggestions of what could be done to still make this
> >> work, but I need you to first see what happens if the native acpi_pad
> >> runs under Xen with the latest upstream code (along with three
> >> patches that are in a BZ I pointed you too).
> > 
> > Do you mean test the patch
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395

Right.
> > ?  
> 
> Ah, you want to test https://bugzilla.redhat.com/show_bug.cgi?id=804347

No. That is a fix on that is required to boot v3.4-rc0 - if you are using
that version.

> Anyway, I didn't have proper h/w platform, but seems the bug (ioapic) is irrelated to pad thread we are talking?

Correct (it is irrelevant).
