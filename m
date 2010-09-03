Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0ICDbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:31:10 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:44426 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755964Ab0ICDbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:31:07 -0400
Message-ID: <4C806BD5.2090000@snapgear.com>
Date: Fri, 3 Sep 2010 13:30:29 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andreas Schwab <schwab@redhat.com>, David Howells <dhowells@redhat.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu
 contributions
References: <19747.1283422807@redhat.com>	<20100902102158.19806.14133.stgit@warthog.procyon.org.uk>	<m38w3kns4r.fsf@hase.home> <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
In-Reply-To: <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 03:30:49.0485 (UTC) FILETIME=[6750FBD0:01CB4B18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Thu, Sep 2, 2010 at 16:21, Andreas Schwab <schwab@redhat.com> wrote:
>> David Howells <dhowells@redhat.com> writes:
>>
>>> Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
>>> the arch defines __uClinux__ for the build.
>> You are using the wrong compiler.
> 
> it would be nice if you could use the same compiler for m68k and m68knommu, at
> least for compiling kernels.

It would be very nice :-)

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
