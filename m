Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2JRXzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:55:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41308 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2JRXzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:55:39 -0400
Date: Thu, 18 Oct 2012 16:55:31 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V3 4/6]: PVH:bootup and setup related
 changes.
Message-ID: <20121018165531.34d2040c@mantra.us.oracle.com>
In-Reply-To: <1350557371.2460.117.camel@zakaz.uk.xensource.com>
References: <20121017173223.7ea1901d@mantra.us.oracle.com>
	<1350557371.2460.117.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012 11:49:31 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Thu, 2012-10-18 at 01:32 +0100, Mukesh Rathor wrote:
> > 
> > +       /* PVH TBD/FIXME: vcpu info placement in phase 2 */
> > +       if (xen_pvh_domain())
> > +               return; 
> 
> Do you have a list of future work before PVH is "feature complete"
> somewhere?
> 
> I wouldn't count vcpu placement specifically against completeness but
> the TBD triggered the thought.
> 
> For example I was reviewing a migration patch this morning and was
> wondering if that sort of thing had been investigated yet.
> 
> Ian.

Yes, I was gonna post it in a separate email, so one can easily
find/track it. 

No, haven't thought of migration, phase II or III.

thanks
Mukesh
