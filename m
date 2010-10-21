Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0JUNoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:44:39 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:49835 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab0JUNoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:44:38 -0400
X-IronPort-AV: E=Sophos;i="4.58,217,1286150400"; 
   d="scan'208";a="2456209"
Date: Thu, 21 Oct 2010 14:44:04 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: xen PV on HVM and initial domain merge in linux-next
In-Reply-To: <20101021104541.8e10159a.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1010211443420.10348@kaball-desktop>
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop> <alpine.DEB.2.00.1010191847290.10348@kaball-desktop> <20101020113256.3647b1d9.sfr@canb.auug.org.au> <alpine.DEB.2.00.1010201455160.10348@kaball-desktop> <20101020152808.GA22328@dumpdata.com>
 <alpine.DEB.2.00.1010201644380.10348@kaball-desktop> <20101021104541.8e10159a.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Stephen Rothwell wrote:
> Hi Stefano,
> 
> On Wed, 20 Oct 2010 16:47:51 +0100 Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> >
> > Good idea, I have created a link called linux-next to
> > 2.6.36-rc8-initial-domain-v5 so the following should also work:
> > 
> > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-next
> 
> I have added that branch from today with just you listed as the contact
> (if you ant anyone else (even a mailing list) listed as a contact, just
> let me know.
> 
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window. 
> 

Thank you!

