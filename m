Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2JOWtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:49:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46376 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2JOWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:49:48 -0400
Date: Mon, 15 Oct 2012 15:49:40 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 0/7]: PVH: PV guest with extensions
Message-ID: <20121015154940.4033c64f@mantra.us.oracle.com>
In-Reply-To: <1350317743.18058.85.camel@zakaz.uk.xensource.com>
References: <20121011144929.06e71a9e@mantra.us.oracle.com>
	<1350317743.18058.85.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 17:15:43 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Thu, 2012-10-11 at 22:49 +0100, Mukesh Rathor wrote:
> > Hi guys,
> > 
> > Ok, I've made all the changes from prev RFC patch submissions.
> > Tested all the combinations. The patches are organized slightly
> > differently from prev version because of the nature of changes
> > after last review. I am building xen patch just for the
> > corresponding header file changes. Following that I'll refresh xen
> > tree, debug, test, and send patches.
> > 
> > For linux kernel mailing list introduction, PVH is a PV guest that
> > can run in an HVM container, uses native pagetables, uses callback
> > vector, native IDT, and native syscalls.
> > 
> > They were built on top of 89d0307af2b9957d59bfb2a86aaa57464ff921de
> > commit.
> 
> Are they in a git branch anywhere?
> 

not in a public accessible location. we are very close to getting this
done (it appears ;)), and once konrad puts in his tree it should be
publicly available.

thanks
mukesh
