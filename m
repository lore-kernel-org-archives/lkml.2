Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab0DHUia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:38:30 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:46843 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab0DHUi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:38:27 -0400
X-MXL-Hash: 4bbe3ec3069bb762-feb7064a82bdc08b304d420da7fd8972244d575b
X-MXL-Hash: 4bbe3ebf3ff8c184-55f072bd2eeed37e384411b8a71b094eb298ea49
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Date: Thu, 8 Apr 2010 15:38:06 -0500
Subject: RE: [PATCH] staging/dt3155: fix build error caused by {write|read}l
 change
Thread-Topic: [PATCH] staging/dt3155: fix build error caused by
 {write|read}l change
Thread-Index: AcrXWe7kbHyIOUHaQY6CiAVRf+i5ggAALk4g
Message-ID: <0D753D10438DA54287A00B0270842697636D3679E8@AUSP01VMBX24.collaborationhost.net>
References: <201003031124.06345.hartleys@visionengravers.com>
 <20100408191123.GB31571@kroah.com>
In-Reply-To: <20100408191123.GB31571@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.178]
X-AnalysisOut: [v=1.0 c=1 a=oMlvMfdrr0IA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=N0rcUYRaQg3G+2kUXxmxxA==:17 a=aloHB68v5hUZolB0wNYA]
X-AnalysisOut: [:9 a=QDu-xvxiT9qWymNUE2ZUsUIu5BEA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 08, 2010 12:11 PM, Greg KH wrote:
> On Wed, Mar 03, 2010 at 11:24:06AM -0700, H Hartley Sweeten wrote:
>> This fixes a build error caused by replacing {Write | Read}MReg with 
>> {write | read}l.
>
> Ick, can you merge this with your other patch so we don't have build
> errors?  I just hit this and I had to drop all of your patches.

I was expecting you to NAK all of them anyway after I saw all the code 
cleanup patches coming in on LKML.

> Can you respin all of them please?

Not a problem.  Are you planning on merging any of the dt3155 cleanup
patches?  If so I will wait until they show up.

Also, should staging patches be based on linux-next or on Linus' git tree?

Regards,
Hartley
