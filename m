Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1IUWKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:10:12 -0400
Received: from ns.theshore.net ([67.18.92.50]:51291 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1IUWKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:10:10 -0400
Message-ID: <4E7A60B4.2010108@theshore.net>
Date: Wed, 21 Sep 2011 18:09:56 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.22) Gecko/20110902 Lightning/1.0b2 Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
References: <4E5BA49D.5060800@theshore.net> <20110829150734.GB24825@dumpdata.com> <1314704744.28989.2.camel@zakaz.uk.xensource.com> <4E5E9CDB.3070706@theshore.net> <20110906171319.GB29839@dumpdata.com> <4E6E2E11.1030602@theshore.net> <20110912161127.GB16100@oracle.com> <4E724ACD.1050207@theshore.net> <4E724F64.5080103@theshore.net> <CEE295A1-B386-4A2A-A16C-9AC29DE174E8@theshore.net> <20110921180423.GC17357@phenom.oracle.com>
In-Reply-To: <20110921180423.GC17357@phenom.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/11 2:04 PM, Konrad Rzeszutek Wilk wrote:
> Excellent. Can you also send me your .config to make sure I've the right
> knobs set?

Certainly.  I included my kernel binary along with its config:

http://www.theshore.net/~caker/xen/BUGS/swapfile/

Thanks!
-Chris
