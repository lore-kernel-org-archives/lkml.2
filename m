Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0E1OOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:14:39 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:59886 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0E1OOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:14:37 -0400
X-IronPort-AV: E=Sophos;i="4.53,318,1272844800"; 
   d="scan'208";a="143394"
Date: Fri, 28 May 2010 15:18:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Zhigang Wang <zhigang.x.wang@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 05/11] Xen PCI platform device driver
In-Reply-To: <4BFF851A.3070201@oracle.com>
Message-ID: <alpine.DEB.2.00.1005281512270.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-5-git-send-email-stefano.stabellini@eu.citrix.com> <4BFF851A.3070201@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Zhigang Wang wrote:
> > +config XEN_PLATFORM_PCI
> > +     tristate "xen platform pci device driver"
> > +     depends on XEN
>         default m
> 
> ?

given the size of the platform pci driver and the fact that blkfront and
netfront are both 'default y' I am going to go with 'default y'  here
too
