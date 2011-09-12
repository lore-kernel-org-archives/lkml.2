Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab1ILQMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:12:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:58141 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319Ab1ILQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:11:59 -0400
Date: Mon, 12 Sep 2011 12:11:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0 Xen
 pv guest - BUG: Unable to handle]
Message-ID: <20110912161127.GB16100@oracle.com>
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
 <4E5BA49D.5060800@theshore.net>
 <20110829150734.GB24825@dumpdata.com>
 <1314704744.28989.2.camel@zakaz.uk.xensource.com>
 <4E5E9CDB.3070706@theshore.net>
 <20110906171319.GB29839@dumpdata.com>
 <4E6E2E11.1030602@theshore.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6E2E11.1030602@theshore.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A02020A.4E6E2F40.0057,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 12:06:41PM -0400, Christopher S. Aker wrote:
> On 9/6/11 1:13 PM, Konrad Rzeszutek Wilk wrote:
> >So .. just to confirm this b/c you have been seeing this for some time. Did you
> >see this with a 2.6.32 DomU? Asking b/c in 2.6.37 we removed some code:
> 
> 2.6.32 was NOT affected and our problems began right around 2.6.37.
> This looks promising!
> 
> >It would really neat if the issue you have been hitting was exactly this
> >and just having you revert the ef691947d8a3d479e67652312783aedcf629320a
> >would fix it.
> 
> Reverted, built, deployed, and set as default.  We shall see!

<holds his fingers crossed>
