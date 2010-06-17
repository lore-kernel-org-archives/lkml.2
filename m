Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485Ab0FQRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:42:28 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:57624 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab0FQRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:42:27 -0400
X-IronPort-AV: E=Sophos;i="4.53,432,1272844800"; 
   d="scan'208";a="465050"
Date: Thu, 17 Jun 2010 18:40:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 03/12] evtchn delivery on HVM
In-Reply-To: <20100617173817.GA17523@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006171839510.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-3-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212040.GC8600@phenom.dumpdata.com> <alpine.DEB.2.00.1006171558570.3401@kaball-desktop>
 <20100617173817.GA17523@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > /* vector callbacks are better than PCI interrupts to receive event
>      ^V
> >  * channel notifications because we can receive vector callbacks on any
> >  * vcpu and we don't need PCI support or APIC interactions */
>                                                             ^.
> > 
> > is it good enough?
> Just two things..
> 

Ok
