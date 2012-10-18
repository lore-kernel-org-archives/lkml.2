Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2JRNrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:47:14 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13424 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2JRNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:47:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,607,1344211200"; 
   d="scan'208";a="15256152"
Message-ID: <1350568030.2460.149.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 5/6] xen: arm: implement remap interfaces needed for
 privcmd mappings.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Thu, 18 Oct 2012 14:47:10 +0100
In-Reply-To: <alpine.DEB.2.02.1210181434420.2689@kaball.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
	 <1350473532-15863-5-git-send-email-ian.campbell@citrix.com>
	 <alpine.DEB.2.02.1210181426090.2689@kaball.uk.xensource.com>
	 <1350567209.2460.145.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1210181434420.2689@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 14:35 +0100, Stefano Stabellini wrote:
> On Thu, 18 Oct 2012, Ian Campbell wrote:
> > On Thu, 2012-10-18 at 14:27 +0100, Stefano Stabellini wrote:
> > > On Wed, 17 Oct 2012, Ian Campbell wrote:
> > > > We use XENMEM_add_to_physmap_range which is the preferred interface
> > > > for foreign mappings.
> > > > 
> > > > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > > 
> > > It looks OK but there are few code style issues, please run the patch
> > > through checkpatch.
> > 
> > The only one I get is:
> > WARNING: please, no spaces at the start of a line
> > #83: FILE: include/xen/interface/memory.h:175:
> > +    uint16_t    size;$
> > 
> > total: 0 errors, 1 warnings, 64 lines checked
> > 
> > The prevailing indentation in that file is 4 spaces so I think we should
> > ignore the warning in this case in the interests of consistency with the
> > surrounding code.
> 
> Strange, I get:

I'm running v3.7-rc1-187-g7bbf07e so it is pretty recent.
[...]

> total: 2 errors, 6 warnings, 162 lines checked

Ah, I was looking at patch 6/6... 

The warnings in this one are all of the same class as before (4 space
indentation). But you are right, the other two need fixing. Done in my
tree.


