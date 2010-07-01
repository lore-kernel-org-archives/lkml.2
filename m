Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0GATo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:44:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61832 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0GATo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:44:56 -0400
MIME-Version: 1.0
Message-ID: <1411749d-666c-447d-bf05-954e2b4adf93@default>
Date: Thu, 1 Jul 2010 12:43:42 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Konrad Wilk <konrad.wilk@oracle.com>
Cc: Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Jeremy@acsinet12.oracle.com, linux-kernel@vger.kernel.org,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: RE: [Xen-devel] Re: [PATCH 0/12] PV on HVM Xen
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
 <20100630175637.GC16488@phenom.dumpdata.com
 alpine.DEB.2.00.1007011111510.30135@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007011111510.30135@kaball-desktop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C2CF026.00B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano --

What versions of Xen are compatible with this series?
I.e. is 4.0 required?  Are all Xen-side changes in
official 4.0.0?  Or only in 4.0-testing (and therefore
will be in 4.0.1)?  Or only in xen-unstable?

If post-4.0.0 xen changes are necessary, could you point
out the changesets?

Thanks,
Dan

P.S. Sorry if I missed earlier discussion or documentation
on this... but if not otherwise documented, maybe the
info should be in the patch comment?

> -----Original Message-----
> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> Sent: Thursday, July 01, 2010 5:39 AM
> To: Konrad Rzeszutek Wilk
> Cc: Fitzhardinge; xen-devel@lists.xensource.com;
> Jeremy@acsinet12.oracle.com; Stefano Stabellini; linux-
> kernel@vger.kernel.org; Don Dutile; Sheng Yang
> Subject: [Xen-devel] Re: [PATCH 0/12] PV on HVM Xen
> 
> On Wed, 30 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jun 21, 2010 at 05:12:20PM +0100, Stefano Stabellini wrote:
> > > Hi all,
> > > this is another update on the PV on HVM Xen series; a list of
> changes
> > > compared to the previous version follows:
> >
> > Can you use the [v4] in the main patch (this is the fourth version of
> > these patches, right?)? I am getting confused as to which version I
> am
> > reviewing and if I've missed one or what not.
> >
> > And in this first intro email state:
> >
> > Since v7 the following things have changed:
> >  - Konrad made some comments.
> >  - etc.
> >
> 
> Good point, I'll do that from now on.
> I am pretty sure that you are reviewing the latest version I sent.
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
