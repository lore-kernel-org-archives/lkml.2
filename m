Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab0FQRjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:39:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46750 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab0FQRjD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Jun 2010 13:39:03 -0400
Date: Thu, 17 Jun 2010 13:38:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 03/12] evtchn delivery on HVM
Message-ID: <20100617173817.GA17523@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1275570645-27189-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <20100614212040.GC8600@phenom.dumpdata.com>
 <alpine.DEB.2.00.1006171558570.3401@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006171558570.3401@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C1A5DA6.00EE:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /* vector callbacks are better than PCI interrupts to receive event
     ^V
>  * channel notifications because we can receive vector callbacks on any
>  * vcpu and we don't need PCI support or APIC interactions */
                                                            ^.
> 
> is it good enough?
Just two things..
