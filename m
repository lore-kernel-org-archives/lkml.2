Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1KUKfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:35:54 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:22170 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab1KUKfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:35:53 -0500
X-IronPort-AV: E=Sophos;i="4.69,546,1315180800"; 
   d="scan'208";a="9035860"
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/granttable: Grant tables V2
 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Mon, 21 Nov 2011 10:35:48 +0000
In-Reply-To: <4ECA1F13.3060903@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
	 <1321451372-13596-1-git-send-email-annie.li@oracle.com>
	 <4EC62FE5.2080608@oracle.com>
	 <1321614166.3664.311.camel@zakaz.uk.xensource.com>
	 <20111118135221.GC12433@phenom.dumpdata.com>
	 <1321624845.3664.354.camel@zakaz.uk.xensource.com>
	 <4EC6837F.1050201@oracle.com> <20111118180500.GA19469@phenom.dumpdata.com>
	 <4ECA1F13.3060903@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321871748.3664.375.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 09:51 +0000, ANNIE LI wrote:
> > The idea is just to have one function. Whichever prints the
> > string and panics the machine. If 'panic' does this properly
> > (and properly meaning it actually prints data when using
> > the earlyprintk=xen as well as console=hvc0) printout system
> > the we cuold just use 'panic' and not worry about it.
> >
> >
> > But if it does not, then we (and by we I mean you) should
> > provide a variant of panic() that prints the data properly using the
> > earlprintk mechanism. Preferrabily to make it generic.
> I did a simple test, a serial cable was connected,  and console=hvc0 was 
> added in grub.conf.
> Whether earlyprintk=xen is set or not, both panic() and xen_raw_printk 
> all can print out strings in gnttab_request_version of grant-table.c.
> 
> So I changed the
> 
> xen_raw_printk();
> panic();
> 
> back to
> 
> panic();

> Other change is the re-arrange "else if" format in 
> gnttab_request_version function.

Neither of these changes are in the attached patch, did you resend an
old one by mistake?

I think a fresh reposting of the series is in order, at least I've
rather lost track of which patches are the most recent ones in this
thread.

Ian.

> 
> Please refer to the patch attached.
> 
> Thanks
> Annie


