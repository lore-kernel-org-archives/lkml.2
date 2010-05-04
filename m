Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab0EDUyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:54:01 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:53330 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab0EDUyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:54:00 -0400
X-MXL-Hash: 4be089671997333e-5d18be9cbeb58c3bd30dacd96715545142478e8b
X-MXL-Hash: 4be089514ad7d9fd-e954d2b3f40e8f6752494100a98be1131641d675
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Joe Perches <joe@perches.com>, Greg KH <gregkh@suse.de>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 4 May 2010 15:53:10 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrryfRBLNqQqwDXS9G4pYZeSMQF/QAAQuRg
Message-ID: <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
References: <20100503185933.GA27346@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
 <20100503211751.GB21402@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
 <20100503234123.GC13519@suse.de>
 <1272931198.30040.218.camel@Joe-Laptop.home>
 <20100504025430.GA26421@suse.de> <1273000031.4143.56.camel@Joe-Laptop.home>
 <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
In-Reply-To: <20100504201207.GA7096@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010050401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=rOUgymgbAAAA:8 a=jEW]
X-AnalysisOut: [yFRgDIKRhgqFlRRIA:9 a=PDTl8nEbc41hUVAWNYNB7yF-UdYA:4 a=Cju]
X-AnalysisOut: [IK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 04, 2010 1:12 PM, Greg KH wrote:
>>> I needed to add a git checkout origin/staging-next
>> 
>> That tree is still missing a couple commits that are in Linus' tree:
>> 
>> commit 6536560cabab170ed2969b005bf69a496e9c45bf
>>     Staging: dt3155: fix 50Hz configuration
>> 
>> commit 74a920139a0f1119c5a604cef0ce5d6f591dc782
>>     staging: fix dt3155 build
>
> Yes, if you look, the staging-next branch starts on Linus's tree as of
> April 8 (just after 2.6.34-rc3).  I don't merge back to Linus's tree a
> bunch, because that is not how it should be done.  When I am going to
> push these to Linus, then I will merge and handle any fixups if needed.

Ok.

>> Which would probably explain the conflict that occurs in linux-next for
>> dt3155_drv.c.
>
> Yes.  And how easy it is to fix up :)

Ok.

>> commit 9e1bd9a6f8c6ad8b461294a365c49b19212178d9
>> Merge: 5382319 e595eea
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Tue May 4 15:42:20 2010 +1000
>> 
>>     Merge remote branch 'staging-next/staging-next'
>>     
>>     Conflicts:
>>         drivers/staging/arlan/arlan-main.c
>>         drivers/staging/comedi/drivers/cb_das16_cs.c
>>         drivers/staging/cx25821/cx25821-alsa.c
>>         drivers/staging/dt3155/dt3155_drv.c
>>         drivers/staging/netwave/netwave_cs.c
>
> That doesn't explain how you aren't seeing the correct stuff to base
> your patches off of though.

I may be seeing the correct stuff now in your staging-next tree just not
in linux-next due to the two commits above.

> Are you _sure_ you have the 'staging-next' branch of the tree checked
> out?

Am I _sure_...  No...  Do I _think_ so...  Yes... ;-)

Would you like me to rebase the patch to staging-next to see?

But, will this run into a similar problem with the two commits already in
Linus' tree?  If so I can just hold off again until everything catches up.

Regards,
Hartley