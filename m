Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab1ILQHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:07:06 -0400
Received: from ns.theshore.net ([67.18.92.50]:36538 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab1ILQHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:07:05 -0400
Message-ID: <4E6E2E11.1030602@theshore.net>
Date: Mon, 12 Sep 2011 12:06:41 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.22) Gecko/20110902 Lightning/1.0b2 Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com> <4E5BA49D.5060800@theshore.net> <20110829150734.GB24825@dumpdata.com> <1314704744.28989.2.camel@zakaz.uk.xensource.com> <4E5E9CDB.3070706@theshore.net> <20110906171319.GB29839@dumpdata.com>
In-Reply-To: <20110906171319.GB29839@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/11 1:13 PM, Konrad Rzeszutek Wilk wrote:
> So .. just to confirm this b/c you have been seeing this for some time. Did you
> see this with a 2.6.32 DomU? Asking b/c in 2.6.37 we removed some code:

2.6.32 was NOT affected and our problems began right around 2.6.37. 
This looks promising!

> It would really neat if the issue you have been hitting was exactly this
> and just having you revert the ef691947d8a3d479e67652312783aedcf629320a
> would fix it.

Reverted, built, deployed, and set as default.  We shall see!

Thanks,
-Chris
