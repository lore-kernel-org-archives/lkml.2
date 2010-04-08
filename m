Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab0DHVIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:08:07 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:35639 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950Ab0DHVID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:08:03 -0400
X-MXL-Hash: 4bbe45b300f82796-d3870ccdb135c76f61714fb623e90ab75dc89a8a
X-MXL-Hash: 4bbe45a24445b355-605a85bf70e5596070156fa4be2a121c812ff367
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Date: Thu, 8 Apr 2010 16:07:12 -0500
Subject: RE: [PATCH] staging/dt3155: fix build error caused by {write|read}l
 change
Thread-Topic: [PATCH] staging/dt3155: fix build error caused by
 {write|read}l change
Thread-Index: AcrXXL03jQ5nuP8wToC1U3qg8H90hAAAJACw
Message-ID: <0D753D10438DA54287A00B0270842697636D367AAB@AUSP01VMBX24.collaborationhost.net>
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
X-SOURCE-IP: [216.166.12.178]
X-AnalysisOut: [v=1.0 c=1 a=oMlvMfdrr0IA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=N0rcUYRaQg3G+2kUXxmxxA==:17 a=qkqwzZHrqiMjKoEU1n8A]
X-AnalysisOut: [:9 a=RJPAb6D6SMkgNs931Skpwb_MRJgA:4 a=CjuIK1q_8ugA:10]
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

I wasn't on the CC list for the ones I noticed on LKML.

A lot of the patches I saw seemed to be duplicate works to clean up the
files.  Plus, some of them appeared that they would conflict in various
ways.  I guess such is the life of a staging driver...

>> Also, should staging patches be based on linux-next or on Linus' git tree?
>
> linux-next please.

Not a problem.  I'll wait a bit to see what shows up before doing anything.

Regards,
Hartley