Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0L3WGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:06:06 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:51937 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0L3WFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:05:54 -0500
Date: Thu, 30 Dec 2010 23:04:06 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH R2 1/7] mm: Add add_registered_memory() to memory hotplug API
Message-ID: <20101230220406.GB17191@router-fw-old.local.net-space.pl>
References: <20101229170212.GF2743@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1012291643290.6040@chino.kir.corp.google.com> <20101230123013.GA12765@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1012301048550.12995@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012301048550.12995@chino.kir.corp.google.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 30, 2010 at 10:49:29AM -0800, David Rientjes wrote:
> On Thu, 30 Dec 2010, Daniel Kiper wrote:
>
> > > Looks like this patch was based on a kernel before 2.6.37-rc4 since it
> > > doesn't have 20d6c96b5f (mem-hotplug: introduce {un}lock_memory_hotplug())
> >
> > As I wrote in "[PATCH R2 0/7] Xen memory balloon driver with memoryhotplug
> > support" this patch applies to Linux kernel Ver. 2.6.36.
> >
>
> I'd suggest posting patches against the latest -git.

Thx, next patch will be based on latest rc.

Daniel
