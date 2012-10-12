Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab2JLJSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:18:36 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:62780 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2JLJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:18:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344211200"; 
   d="scan'208";a="15121513"
Message-ID: <1350033511.14806.64.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 0/7]: PVH: PV guest with extensions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 10:18:31 +0100
In-Reply-To: <20121011144929.06e71a9e@mantra.us.oracle.com>
References: <20121011144929.06e71a9e@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 22:49 +0100, Mukesh Rathor wrote:
> Hi guys,
> 
> Ok, I've made all the changes from prev RFC patch submissions. Tested
> all the combinations. The patches are organized slightly differently
> from prev version because of the nature of changes after last review. I
> am building xen patch just for the corresponding header file changes.
> Following that I'll refresh xen tree, debug, test, and send patches.
> 
> For linux kernel mailing list introduction, PVH is a PV guest that can
> run in an HVM container, uses native pagetables, uses callback vector,
> native IDT, and native syscalls.
> 
> They were built on top of 89d0307af2b9957d59bfb2a86aaa57464ff921de
> commit.

I took a (fairly quick) look. I had a few comments but overall looks
pretty good, thanks!

I'm constantly amazed by how small this patchset is. I suspect you are
going to make up for it in the hypervisor side ;-)

Ian.

