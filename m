Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1C2NXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:23:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55938 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1C2NXp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 29 Mar 2011 09:23:45 -0400
Date: Tue, 29 Mar 2011 09:23:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        andi.kleen@intel.com, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: Extend memory hotplug API to allow memory
 hotplug in virtual machines
Message-ID: <20110329132311.GA28815@dumpdata.com>
References: <20110328092507.GD13826@router-fw-old.local.net-space.pl>
 <20110328153735.d797c5b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328153735.d797c5b3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D91DD41.0148,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I merged your patch 1/3.
> 
> I skipped your patch 2/3, as the new macros appear to have no callers
> in this patchset.
> 
> I suggest that once we're happy with them, your patches 2 and 3 be
> merged up via whichever tree merges the Xen balloon driver changes. 
> That might be my tree, I forget :) Was anyone else thinking of grabbing
> them?

That would be. I can carry that pathces if this is easier for you.
Would need the Ack-by at some point from mm maintainers when the patches are
to everybody's satisfaction.

