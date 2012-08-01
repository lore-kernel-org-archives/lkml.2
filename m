Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2HASUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:20:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32873 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2HASUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:20:09 -0400
Date: Wed, 1 Aug 2012 11:19:37 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 20/24] xen: update xen_add_to_physmap interface
Message-ID: <20120801111937.4c9b3702@mantra.us.oracle.com>
In-Reply-To: <20120801145215.GP7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	<1343316846-25860-20-git-send-email-stefano.stabellini@eu.citrix.com>
	<20120801145215.GP7227@phenom.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012 10:52:15 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Thu, Jul 26, 2012 at 04:34:02PM +0100, Stefano Stabellini wrote:
> > Update struct xen_add_to_physmap to be in sync with Xen's version
> > of the structure.
> > The size field was introduced by:
> > 
> > changeset:   24164:707d27fe03e7
> > user:        Jean Guyader <jean.guyader@eu.citrix.com>
> > date:        Fri Nov 18 13:42:08 2011 +0000
> > summary:     mm: New XENMEM space, XENMAPSPACE_gmfn_range
> > 
> > According to the comment:
> > 
> > "This new field .size is located in the 16 bits padding
> > between .domid and .space in struct xen_add_to_physmap to stay
> > compatible with older versions."
> > 
> > This is not true on ARM where there is not padding, but it is valid
> > on X86, so introducing size is safe on X86 and it is going to fix
> > the interace for ARM.
> 
> Has this been checked actually for backwards compatibility? It sounds
> like it should work just fine with Xen 4.0 right?
> 
> I believe this also helps Mukesh's patches, so CC-ing him here for
> his Ack.

Yup, I already had that change in my tree.

thanks,
Mukesh


