Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0JTP0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:26:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60947 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0JTP0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:26:30 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
CC: "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 20 Oct 2010 10:26:24 -0500
Subject: RE: [PATCHv4 4/4] iommu: create new api to set valid da range
Thread-Topic: [PATCHv4 4/4] iommu: create new api to set valid da range
Thread-Index: ActwOPdExtplr7a9SX2pGcFDbZm6QAAMeH0g
Message-ID: <496565EC904933469F292DDA3F1663E602F4935CE1@dlee06.ent.ti.com>
References: <AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
	<20101020.114516.189725260.Hiroshi.DOYU@nokia.com>
	<AANLkTimpmoDY+nDERsTQ_FK0k_vkPjOi=ttbdtt2LpPs@mail.gmail.com>
 <20101020.122638.112626316.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20101020.122638.112626316.Hiroshi.DOYU@nokia.com>
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
> From: Hiroshi DOYU [mailto:Hiroshi.DOYU@nokia.com] 
> Sent: Wednesday, October 20, 2010 4:27 AM
> To: felipe.contreras@gmail.com
> Cc: Guzman Lugo, Fernando; felipe.contreras@nokia.com; 
> david.cohen@nokia.com; linux-kernel@vger.kernel.org; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
> 
> From: ext Felipe Contreras <felipe.contreras@gmail.com>
> Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
> Date: Wed, 20 Oct 2010 10:58:16 +0200
> 
> > On Wed, Oct 20, 2010 at 11:45 AM, Hiroshi DOYU 
> <Hiroshi.DOYU@nokia.com> wrote:
> >> From: "ext felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
> >> Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da 
> >> range
> >> Date: Wed, 20 Oct 2010 10:35:50 +0200
> >>
> >>> On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo 
> <x0095840@ti.com> wrote:
> >>>> Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
> >>>> With this new API the valid range can be set.
> >>>>
> >>>> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> >>>
> >>> I don't see the point in having an API. It could be done through 
> >>> platform data, and the usage of 0xFFFFF000 instead of 
> ULONG_MAX is 
> >>> independent of this.
> >>
> >> Using platform data is better, but why dropping da_end?
> > 
> > Because it's always 0xFFFFF000. Do you know of any instance 
> where it's 
> >not?
> 
> We should try to avoid forcing unnecessary limitations and 
> dependencies. The usage of device virtual address space range 
> depends on dsp(coprocessor) side S/W implimentation or configuration.

I am agree. The valid range depends on the user (dsp or something else)
The only limitation of see in the iommu is that range has to be
Page aligned and that should be the only limitation.

Regards,
Fernando.

> 