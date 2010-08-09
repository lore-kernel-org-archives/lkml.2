Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0HIUs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:48:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55882 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0HIUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:48:57 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
Organization: IBM - LTC
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 8/8] v5  Update memory-hotplug documentation
Date: Mon, 9 Aug 2010 13:48:41 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-preempt; KDE/4.4.2; x86_64; ; )
Cc: linuxppc-dev@ozlabs.org, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <4C60407C.2080608@austin.ibm.com> <4C604C62.7060509@austin.ibm.com> <201008091344.37878.nacc@us.ibm.com>
In-Reply-To: <201008091344.37878.nacc@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008091348.42256.nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 09, 2010 01:44:37 pm Nishanth Aravamudan wrote:
> On Monday, August 09, 2010 11:43:46 am Nathan Fontenot wrote:
> > Update the memory hotplug documentation to reflect the new behaviors of
> > memory blocks reflected in sysfs.
> 
> <snip>
> 
> > Index: linux-2.6/Documentation/memory-hotplug.txt
> > ===================================================================
> > --- linux-2.6.orig/Documentation/memory-hotplug.txt	2010-08-09 07:36:48.000000000 -0500
> > +++ linux-2.6/Documentation/memory-hotplug.txt	2010-08-09 07:59:54.000000000 -0500
> 
> <snip>
> 
> > -/sys/devices/system/memory/memoryXXX/phys_index
> > +/sys/devices/system/memory/memoryXXX/start_phys_index
> > +/sys/devices/system/memory/memoryXXX/end_phys_index
> >  /sys/devices/system/memory/memoryXXX/phys_device
> >  /sys/devices/system/memory/memoryXXX/state
> >  /sys/devices/system/memory/memoryXXX/removable
> > 
> > -'phys_index' : read-only and contains section id, same as XXX.
> 
> <snip>
> 
> > +'phys_index'      : read-only and contains section id of the first section
> 
> Shouldn't this be "start_phys_index"?

Ah, actually it's that the Documentation change doesn't seem to agree with
patch 2/8 ? That is, 2/8 leaves phys_index in place, but changes several
variables, while this patch indicates its removal?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
Linux Technology Center
