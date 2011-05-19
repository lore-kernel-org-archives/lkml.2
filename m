Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1ESDJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:09:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6008 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab1ESDJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jOin1nKo5/JT/hXfmCrWN87hLIKv3lWQvPMN3WyrATFMjpXhcS919CPtpb1K973wV/
         KPTlLQ+O6MP60RZiJ4Fg==
Date: Wed, 18 May 2011 20:09:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V3 0/2] mm: Memory hotplug interface changes
In-Reply-To: <20110518151131.GB4709@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1105182008160.20651@chino.kir.corp.google.com>
References: <20110517213604.GA30232@router-fw-old.local.net-space.pl> <20110518151131.GB4709@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, Konrad Rzeszutek Wilk wrote:

> > Full list of futures:
> >   - mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro,
> >   - mm: Extend memory hotplug API to allow memory hotplug in virtual
> >     machines.
> > 
> > Those patches applies to Linus' git tree, v2.6.39-rc7 tag with a few
> > prerequisite patches available at https://lkml.org/lkml/2011/5/2/296.
> 
> Are they in akpm tree?
> 
> Dave and David, you guys Acked them - are they suppose to go through your
> tree(s) or Andrew's?
> 

All of the prerequisite patches are in mmotm-2011-05-12-15-52 already.  
See http://userweb.kernel.org/~akpm/mmotm/
