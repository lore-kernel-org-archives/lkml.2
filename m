Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab0JVQ1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:27:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45088 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab0JVQ1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:27:37 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 22 Oct 2010 11:23:34 -0500
Subject: RE: [PATCHv4 4/4] iommu: create new api to set valid da range
Thread-Topic: [PATCHv4 4/4] iommu: create new api to set valid da range
Thread-Index: Actxz8kGD8q7Irv4RmuJmYRTcffeAwANYDpQ
Message-ID: <496565EC904933469F292DDA3F1663E602F4936594@dlee06.ent.ti.com>
References: <1287542932-14206-1-git-send-email-x0095840@ti.com>
	<1287542932-14206-2-git-send-email-x0095840@ti.com>
	<1287542932-14206-3-git-send-email-x0095840@ti.com>
	<1287542932-14206-4-git-send-email-x0095840@ti.com>
	<1287542932-14206-5-git-send-email-x0095840@ti.com>
	<AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F4935CD8@dlee06.ent.ti.com>
	<AANLkTikawFKKLkT_CRw4HbeTsiSoJyd70k2e3a0F5Fr7@mail.gmail.com>
 <AANLkTikCsBCoT55BXvSJEkKYh8M0mMLBag_MR4-aBsEk@mail.gmail.com>
In-Reply-To: <AANLkTikCsBCoT55BXvSJEkKYh8M0mMLBag_MR4-aBsEk@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Felipe Contreras [mailto:felipe.contreras@gmail.com] 
> Sent: Friday, October 22, 2010 4:59 AM
> To: Guzman Lugo, Fernando
> Cc: Hiroshi.DOYU@nokia.com; felipe.contreras@nokia.com; 
> david.cohen@nokia.com; linux-kernel@vger.kernel.org; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
> 
> On Wed, Oct 20, 2010 at 7:26 PM, Felipe Contreras 
> <felipe.contreras@gmail.com> wrote:
> > On Wed, Oct 20, 2010 at 6:22 PM, Guzman Lugo, Fernando 
> > <fernando.lugo@ti.com> wrote:
> >>> On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo 
> >>> <x0095840@ti.com> wrote:
> >>> > Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
> >>> > With this new API the valid range can be set.
> >>> >
> >>> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> >>>
> >>> I don't see the point in having an API. It could be done
> >>
> >> Thanks to this api we can make this:
> >>
> >> A new kconfig parameter for DMM size is added. Also DMM is 
> allocated 
> >> in the last part of the IVA MMU capable address.
> >> So that DMM address are far away of shared memory address reducing 
> >> the probability of shared memory corruption.
> >
> > Ok, that's why it's usually a good idea to send a patch 
> that makes use 
> > of the new API.
> 
> Oh, and some more comments: Hiroshi wanted the end address 
> too, but also on the platform data.

I will try that.

> 
> And please use a sensible prefix, like "omap: iommu: ", if you only do
> "iommu: " it can be confused with other parts of the system, 
> specially if you send to lkml.

Sure, I wil take care for that.

Thanks and regards,
Fernando.

> 
> --
> Felipe Contreras
> 