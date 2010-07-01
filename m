Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0GASVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:21:03 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:50214 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab0GASVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:21:00 -0400
X-MXL-Hash: 4c2cdc8c620bcd84-df6ddacbac5df0c79c707c4264853cd4ca9c6a54
X-MXL-Hash: 4c2cdc8874a6436d-0bec4ebe1e1abe355c5f90accc68afef76c09cf4
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Date: Thu, 1 Jul 2010 13:19:56 -0500
Subject: RE: [PATCH] Staging: dt3155_isr: cleanup fbuffer usage
Thread-Topic: [PATCH] Staging: dt3155_isr: cleanup fbuffer usage
Thread-Index: AcsZScelL4OgSJppTliZlxPg7demfwAAByWA
Message-ID: <0D753D10438DA54287A00B02708426976373859459@AUSP01VMBX24.collaborationhost.net>
References: <201006251514.10068.hartleys@visionengravers.com>
 <0D753D10438DA54287A00B02708426976373859415@AUSP01VMBX24.collaborationhost.net>
 <20100701181727.GA3247@suse.de>
In-Reply-To: <20100701181727.GA3247@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010062801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=uN3pKissNAMA:10 a=hO-oPbc3tlwA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=VU]
X-AnalysisOut: [CU1Qu8jvU1roXvovwA:9 a=qyvEUrHCYbz8rzSlbGIy1Qhu46EA:4 a=Cj]
X-AnalysisOut: [uIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 01, 2010 11:17 AM, Greg KH wrote:
> On Thu, Jul 01, 2010 at 01:09:51PM -0500, H Hartley Sweeten wrote:
>> Ping...
>> 
>> Any comments on this patch?
>
> Give me some time, I've been working on the -stable releases this week.
> It's in my "todo" queue to get to after this is all done...

Not a problem.

Keep up the great work!

Regards,
Hartley