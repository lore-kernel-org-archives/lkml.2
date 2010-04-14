Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0DNAvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:51:05 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:60819 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0DNAvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:51:03 -0400
X-MXL-Hash: 4bc511775acd5da9-0dd822fafb408a0f75886ab532572a3accbe909e
X-MXL-Hash: 4bc511707c7c130e-b1f9ef345a4c0d234074eb171c453e436b4743ad
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Date: Tue, 13 Apr 2010 19:50:51 -0500
Subject: RE: [PATCH] staging/dt3155: fix build error caused by {write|read}l
 change
Thread-Topic: [PATCH] staging/dt3155: fix build error caused by
 {write|read}l change
Thread-Index: AcrXXL03jQ5nuP8wToC1U3qg8H90hAEDzfSA
Message-ID: <0D753D10438DA54287A00B0270842697636D5B7876@AUSP01VMBX24.collaborationhost.net>
References: <201003031124.06345.hartleys@visionengravers.com>
 <20100408191123.GB31571@kroah.com>
 <0D753D10438DA54287A00B0270842697636D3679E8@AUSP01VMBX24.collaborationhost.net>
 <20100408204613.GA25396@kroah.com>
In-Reply-To: <20100408204613.GA25396@kroah.com>
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
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=oMlvMfdrr0IA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=VwQbUJbxAAAA:8 a=i00]
X-AnalysisOut: [gxMtYAAAA:8 a=qkqwzZHrqiMjKoEU1n8A:9 a=7_2RDqUfGhCHlAgKaYU]
X-AnalysisOut: [A:7 a=7i5jFvWiKeDEYncVLj-Quu8qakYA:4 a=CjuIK1q_8ugA:10 a=L]
X-AnalysisOut: [I9Vle30uBYA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 08, 2010 1:46 PM, Greg KH wrote:
> On Thu, Apr 08, 2010 at 03:38:06PM -0500, H Hartley Sweeten wrote:
>> On Thursday, April 08, 2010 12:11 PM, Greg KH wrote:
>>> On Wed, Mar 03, 2010 at 11:24:06AM -0700, H Hartley Sweeten wrote:
>>>> This fixes a build error caused by replacing {Write | Read}MReg with 
>>>> {write | read}l.
>>>
>>> Ick, can you merge this with your other patch so we don't have build
>>> errors?  I just hit this and I had to drop all of your patches.
>> 
>> I was expecting you to NAK all of them anyway after I saw all the code 
>> cleanup patches coming in on LKML.
>> 
>>> Can you respin all of them please?
>> 
>> Not a problem.  Are you planning on merging any of the dt3155 cleanup
>> patches?  If so I will wait until they show up.
>
> I took some, you should have gotten the responses now.

Hello Greg,

Do you know off hand what (if any) of the dt3155 patches you took and when
they might show up in linux-next?  The last commits in next-20100413 are:

commit 5a0e3ad6af8660be21ca98a971cd00f331318c05
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Mar 24 17:04:11 2010 +0900

    include cleanup: Update gfp.h and slab.h includes to prepare for breaking implicit slab.h inclusion from p

commit 3a8954e8f22cf31791d8c524c2839433e39f9368
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Fri Feb 26 17:58:07 2010 -0700

    staging: dt3155: revert u_long to u64 usage

Regards,
Hartley