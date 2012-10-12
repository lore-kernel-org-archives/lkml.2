Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2JLVSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:18:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34426 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2JLVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:18:38 -0400
Date: Fri, 12 Oct 2012 14:18:30 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 0/7]: PVH: PV guest with extensions
Message-ID: <20121012141830.514c68c2@mantra.us.oracle.com>
In-Reply-To: <1350033511.14806.64.camel@zakaz.uk.xensource.com>
References: <20121011144929.06e71a9e@mantra.us.oracle.com>
	<1350033511.14806.64.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 10:18:31 +0100
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
> I took a (fairly quick) look. I had a few comments but overall looks
> pretty good, thanks!
> 
> I'm constantly amazed by how small this patchset is. I suspect you are
> going to make up for it in the hypervisor side ;-)

Hehe... yes! The patch has become almost half since I first got it
working. Each review trims it down :).

thanks
Mukesh
