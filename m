Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0GBKni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:43:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:4213 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0GBKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:43:36 -0400
X-IronPort-AV: E=Sophos;i="4.53,526,1272844800"; 
   d="scan'208";a="709394"
Date: Fri, 2 Jul 2010 11:43:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Konrad Wilk <konrad.wilk@oracle.com>, Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Jeremy@acsinet12.oracle.com" <Jeremy@acsinet12.oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: RE: [Xen-devel] Re: [PATCH 0/12] PV on HVM Xen
In-Reply-To: <1411749d-666c-447d-bf05-954e2b4adf93@default>
Message-ID: <alpine.DEB.2.00.1007021132390.29110@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <20100630175637.GC16488@phenom.dumpdata.com alpine.DEB.2.00.1007011111510.30135@kaball-desktop> <1411749d-666c-447d-bf05-954e2b4adf93@default>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Dan Magenheimer wrote:
> Hi Stefano --
> 
> What versions of Xen are compatible with this series?
> I.e. is 4.0 required?  Are all Xen-side changes in
> official 4.0.0?  Or only in 4.0-testing (and therefore
> will be in 4.0.1)?  Or only in xen-unstable?
> 
> If post-4.0.0 xen changes are necessary, could you point
> out the changesets?
> 


Any Xen version is going to work, but you need unstable to get all the
features.

In particular you need these patches:

- 21647: implement HVMOP_pagetable_dying

- 21493: update_runstate_area for 32 bit PV on HVM guests

- 21449: implement vector callback for evtchn delivery

- 21445: TSC handling cleanups (version 2)

- 21341: Export timer hypercalls to HVM guests too

- 21339: TSC handling cleanups


