Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1C3P6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:58:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57354 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1C3P6o (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Mar 2011 11:58:44 -0400
Date: Wed, 30 Mar 2011 11:58:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] xen/balloon: Cleanups and fixes for 2.6.40
Message-ID: <20110330155804.GB17427@dumpdata.com>
References: <20110328093128.GE13826@router-fw-old.local.net-space.pl>
 <1301409001.18413.11.camel@zakaz.uk.xensource.com>
 <4D92087D.3090600@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D92087D.3090600@tycho.nsa.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D93530F.001D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:27:41PM -0400, Daniel De Graaf wrote:
> On 03/29/2011 10:30 AM, Ian Campbell wrote:
> > On Mon, 2011-03-28 at 10:31 +0100, Daniel Kiper wrote:
> >> Hi,
> >>
> >> Full list of cleanups/fixes:
> >>   - xen/balloon: Use PageHighMem() for high memory page detection,
> >>   - xen/balloon: Simplify HVM integration,
> >>   - xen/balloon: Clarify credit calculation,
> >>   - xen/balloon: Move dec_totalhigh_pages() from __balloon_append() to balloon_append().
> >>
> >> Those patches applies to latest Linus' git tree
> >> (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git).
> >> They are required by latest memory hotplug support for Xen balloon
> >> driver patch which will be sent soon.
> > 
> > This series looks sane to me, so:
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > CC'ing Daniel De Graaf though since he has been working on the balloon
> > driver recently as well.
> > 
> > Ian.
> > 
> The series also looks fine to me.

OK. I stuck 'em in devel/balloon.cleanup and will include them in 2.6.40 train.
