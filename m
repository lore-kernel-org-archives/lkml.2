Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab1ERPMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:12:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40939 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ERPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:12:13 -0400
Date: Wed, 18 May 2011 11:11:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V3 0/2] mm: Memory hotplug interface changes
Message-ID: <20110518151131.GB4709@dumpdata.com>
References: <20110517213604.GA30232@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517213604.GA30232@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DD3E1B4.0146:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 11:36:04PM +0200, Daniel Kiper wrote:
> Hi,
> 
> Full list of futures:
>   - mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro,
>   - mm: Extend memory hotplug API to allow memory hotplug in virtual
>     machines.
> 
> Those patches applies to Linus' git tree, v2.6.39-rc7 tag with a few
> prerequisite patches available at https://lkml.org/lkml/2011/5/2/296.

Are they in akpm tree?

Dave and David, you guys Acked them - are they suppose to go through your
tree(s) or Andrew's?
