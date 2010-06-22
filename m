Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0FVXgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:36:17 -0400
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:39089 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0FVXgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:36:16 -0400
X-MXL-Hash: 4c2148f053309065-9c9dd4b2ebf567fa02a316b395a63a66bf6da1c0
X-MXL-Hash: 4c2148ef34b90e43-03da148fc3b35c2e25c5013824efa4cc5ad2f42b
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>
Date: Tue, 22 Jun 2010 18:36:00 -0500
Subject: RE: [PATCH v2] Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: [PATCH v2] Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcsSX2mv/HxZUIp1RV+sDltgt5OAYgAAOKng
Message-ID: <0D753D10438DA54287A00B02708426976371650529@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
 <20100504210229.GA21128@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
 <20100506202535.GA28600@kroah.com>
 <0D753D10438DA54287A00B027084269763715265FE@AUSP01VMBX24.collaborationhost.net>
 <20100622223913.GA28119@kroah.com>
 <0D753D10438DA54287A00B027084269763716504D6@AUSP01VMBX24.collaborationhost.net>
 <20100622230428.GA2854@kroah.com>
In-Reply-To: <20100622230428.GA2854@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010061701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=DjL9fr-YSJ0A:10 a=yQWWgrYGNuUA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=Pr5KuayN0fUuYEjKLVMA:9 a=AFriEOGa304b4DxAVu]
X-AnalysisOut: [UA:7 a=HvJ9E_pICF0kQ0Tp_3waoLwWn8IA:4 a=CjuIK1q_8ugA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 4:04 PM, Greg KH wrote:
> On Tue, Jun 22, 2010 at 05:45:32PM -0500, H Hartley Sweeten wrote:
>> On Tuesday, June 22, 2010 3:39 PM, Greg KH wrote:
>>> You are still doing something odd, this one doesn't apply either.  Is
>>> your email client messing something up?
>>>
>>> strange.
>> 
>> Hmm. I thought I had that worked out since I haven't had any problems lately.
>> 
>> Can you please try this one?
>
> Nope, I get the following errors:
>
>
>>tching file drivers/staging/dt3155/dt3155_drv.c
> Hunk #2 FAILED at 112.
> Hunk #7 succeeded at 214 with fuzz 2.
> Hunk #8 succeeded at 234 with fuzz 2.
> Hunk #9 FAILED at 252.
> Hunk #10 succeeded at 260 with fuzz 2.
> Hunk #12 succeeded at 313 with fuzz 2.
> Hunk #13 FAILED at 390.
> Hunk #14 succeeded at 405 with fuzz 2.
> Hunk #16 FAILED at 433.
> Hunk #17 FAILED at 451.
> Hunk #22 succeeded at 915 with fuzz 1.
> Hunk #23 succeeded at 1040 with fuzz 2.
> 5 out of 23 hunks FAILED -- saving rejects to file drivers/staging/dt3155/dt3155_drv.c.rej
> patching file drivers/staging/dt3155/dt3155_drv.h
> patching file drivers/staging/dt3155/dt3155_io.c
> Hunk #2 FAILED at 77.
> Hunk #3 FAILED at 103.
> Hunk #4 FAILED at 119.
> Hunk #5 FAILED at 134.
> Hunk #6 FAILED at 151.
> 5 out of 6 hunks FAILED -- saving rejects to file drivers/staging/dt3155/dt3155_io.c.rej
> patching file drivers/staging/dt3155/dt3155_io.h
> Reversed (or previously applied) patch detected!  Assume -R? [n] 
> 
> not good...

Now I'm really confused.

~/src/git/linux-next $ patch --dry-run -p1 -i ../patches/dt3155_mmio_v2.patch 
patching file drivers/staging/dt3155/dt3155_drv.c
patching file drivers/staging/dt3155/dt3155_drv.h
patching file drivers/staging/dt3155/dt3155_io.c
patching file drivers/staging/dt3155/dt3155_io.h

~/src/git/staging-next-2.6 $ patch --dry-run -p1 -i ../patches/dt3155_mmio_v2.patch 
patching file drivers/staging/dt3155/dt3155_drv.c
Hunk #2 succeeded at 115 (offset 3 lines).
Hunk #3 succeeded at 140 (offset 3 lines).
Hunk #4 succeeded at 172 (offset 3 lines).
Hunk #5 succeeded at 189 (offset 3 lines).
Hunk #6 succeeded at 204 (offset 3 lines).
Hunk #7 succeeded at 215 (offset 3 lines).
Hunk #8 succeeded at 235 (offset 3 lines).
Hunk #9 succeeded at 253 (offset 3 lines).
Hunk #10 succeeded at 261 (offset 3 lines).
Hunk #11 succeeded at 278 (offset 3 lines).
Hunk #12 succeeded at 314 (offset 3 lines).
Hunk #13 succeeded at 391 (offset 3 lines).
Hunk #14 succeeded at 406 (offset 3 lines).
Hunk #15 succeeded at 423 (offset 3 lines).
Hunk #16 succeeded at 434 (offset 3 lines).
Hunk #17 succeeded at 449 (offset 3 lines).
Hunk #18 succeeded at 460 (offset 3 lines).
Hunk #19 succeeded at 482 (offset 3 lines).
Hunk #20 succeeded at 491 (offset 3 lines).
Hunk #21 succeeded at 706 (offset 2 lines).
Hunk #22 succeeded at 908 (offset 2 lines).
Hunk #23 succeeded at 1033 (offset 2 lines).
patching file drivers/staging/dt3155/dt3155_drv.h
patching file drivers/staging/dt3155/dt3155_io.c
patching file drivers/staging/dt3155/dt3155_io.h

Locally the patch applies fine against linux-next (next-20100622). And it applies
against your staging-next tree with some fuzz due to the following commits not in
that tree.

commit a46f9087e634224b3d0a6560e223425816846dff
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Tue Jun 8 10:36:57 2010 -0500

    Staging: dt3155: remove DT_3155_* errno defines

commit 0f3ff30b9384ffa1b435f263234531582080b100
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Mon Jun 7 13:25:37 2010 -0500

    Staging: dt3155: fix different address spaces noise in dt3155_drv.c

But, the patch in the mail does not apply. I get the same errors you have above.

Comparing the two files it appears my client does screw with the line endings.
This has been working fine so I'm not sure what changed. I will resend the
patch with a different client to see if that fixes the problem.

Thanks,
Hartley