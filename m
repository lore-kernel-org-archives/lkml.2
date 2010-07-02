Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab0GBQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:09:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30463 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab0GBQJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:09:25 -0400
MIME-Version: 1.0
Message-ID: <9d5fb841-26be-4ce1-b549-eb7f17f88e61@default>
Date: Fri, 2 Jul 2010 09:08:43 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Konrad Wilk <konrad.wilk@oracle.com>, Jeremy@acsinet12.oracle.com,
       linux-kernel@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: RE: [Xen-devel] Re: [PATCH 0/12] PV on HVM Xen
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
 <20100630175637.GC16488@phenom.dumpdata.com>
 <alpine.DEB.2.00.1007011111510.30135@kaball-desktop>
 <1411749d-666c-447d-bf05-954e2b4adf93@default
 alpine.DEB.2.00.1007021132390.29110@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007021132390.29110@kaball-desktop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C2E0F12.0215:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> 
> On Thu, 1 Jul 2010, Dan Magenheimer wrote:
> > Hi Stefano --
> >
> > What versions of Xen are compatible with this series?
> > I.e. is 4.0 required?  Are all Xen-side changes in
> > official 4.0.0?  Or only in 4.0-testing (and therefore
> > will be in 4.0.1)?  Or only in xen-unstable?
> >
> > If post-4.0.0 xen changes are necessary, could you point
> > out the changesets?
> 
> Any Xen version is going to work, but you need unstable to get all the
> features.
> 
> In particular you need these patches:
> 
> - 21647: implement HVMOP_pagetable_dying
> 
> - 21493: update_runstate_area for 32 bit PV on HVM guests
> 
> - 21449: implement vector callback for evtchn delivery
> 
> - 21445: TSC handling cleanups (version 2)
> 
> - 21341: Export timer hypercalls to HVM guests too
> 
> - 21339: TSC handling cleanups

Thanks for the thorough reply!  Any reason that any of these
cannot or should not be back-ported to go into 4.0.1?

Thanks,
Dan
