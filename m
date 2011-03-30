Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1C3O0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:26:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49284 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab1C3O0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:26:39 -0400
Subject: Re: [PATCH 3/3] mm: Extend memory hotplug API to allow memory
 hotplug in virtual machines
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110329183242.GE30387@router-fw-old.local.net-space.pl>
References: <20110328092507.GD13826@router-fw-old.local.net-space.pl>
	 <1301329524.31700.8440.camel@nimitz>
	 <20110329183242.GE30387@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 30 Mar 2011 07:26:16 -0700
Message-ID: <1301495176.21454.3736.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 20:32 +0200, Daniel Kiper wrote:
> > Your stuff already extracted the free stuff very nicely.  I think now we
> > just need to separate out the totalram_pages/totalhigh_pages bits from
> > the num_physpages/max_mapnr ones.
> 
> What do you think about __online_page_increment_counters()
> (totalram_pages and totalhigh_pages) and
> __online_page_set_limits() (num_physpages and max_mapnr) ??? 

I think there's a point when "online_page" in there becomes unnecessary,
but those sound OK to me.

-- Dave

