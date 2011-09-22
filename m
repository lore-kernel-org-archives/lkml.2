Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1IVUCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:02:49 -0400
Received: from ns.theshore.net ([67.18.92.50]:50116 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab1IVUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:02:47 -0400
Message-ID: <4E7B945B.1020608@theshore.net>
Date: Thu, 22 Sep 2011 16:02:35 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.22) Gecko/20110902 Lightning/1.0b2 Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Shaun R <mailinglists@unix-scripts.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com> <4E5BA49D.5060800@theshore.net> <20110829150734.GB24825@dumpdata.com> <1314704744.28989.2.camel@zakaz.uk.xensource.com> <4E5E9CDB.3070706@theshore.net> <20110922183232.GA23825@phenom.oracle.com>
In-Reply-To: <20110922183232.GA23825@phenom.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/11 2:32 PM, Konrad Rzeszutek Wilk wrote:
> This is the patch that looks to be doing the trick. Please double check
> if it fixes in your guys setup.

So far it's looking good.  Before I was able to BUG it within 2 or 3 
minutes.  This patched kernel has held up for the past hour and counting.

Nice work, and many thanks!

-Chris
