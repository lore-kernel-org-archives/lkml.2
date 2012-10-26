Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2JZBib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:38:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50690 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2JZBia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:38:30 -0400
Date: Thu, 25 Oct 2012 18:38:22 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 5/5] xen: x86 pvh: use
 XENMEM_add_to_physmap_range for foreign gmfn mappings
Message-ID: <20121025183822.1ec77078@mantra.us.oracle.com>
In-Reply-To: <1351084777-28898-5-git-send-email-ian.campbell@citrix.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
	<1351084777-28898-5-git-send-email-ian.campbell@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 14:19:37 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> Squeezing the necessary fields into the existing XENMEM_add_to_physmap
> interface was proving to be a bit tricky so we have decided to go with
> a new interface upstream (the XENMAPSPACE_gmfn_foreign interface using
> XENMEM_add_to_physmap was never committed anywhere). This interface
> also allows for batching which was impossible to support at the same
> time as foreign mfns in the old interface.
> 
> This reverts the relevant parts of "PVH: basic and header changes,
> elfnote changes, ..." and followups and trivially converts
> pvh_add_to_xen_p2m over.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Ok, I made the change on the xen side for x86 and tested it out. Works
fine. Second ack.

thanks, 
Mukesh

