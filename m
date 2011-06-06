Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1FFO5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:57:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60564 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1FFO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:57:39 -0400
Date: Mon, 6 Jun 2011 10:56:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, ian.campbell@citrix.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V4] mm: Extend memory hotplug API to allow memory hotplug
 in virtual machines
Message-ID: <20110606145644.GB29243@dumpdata.com>
References: <20110524222733.GA29133@router-fw-old.local.net-space.pl>
 <20110602122607.3122e23b.akpm@linux-foundation.org>
 <20110605163806.GA12527@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605163806.GA12527@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4DECEAC8.00C2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is there any propsect that the other virtualisation schemes will use
> > this facility?  If not, why not?
> 
> I think about that. Even I put a project proposal for GSoC 2011 (you
> could find more details here

Plus .. I remember reading on LWN something about this year's Linux MMU conference
and Red Hat's guys wanting to leverage a generic implemenation for the ballooning
and make it more "self-aware" for KVM.
