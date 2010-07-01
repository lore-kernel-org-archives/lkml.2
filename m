Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0GAS0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:26:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38773 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123Ab0GAS0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:26:42 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohad@wizery.com" <ohad@wizery.com>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 1 Jul 2010 13:26:35 -0500
Subject: RE: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Topic: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Index: AcsYr29geLDqkvcsTwW6nxBnghiRywAkS5RwAAFMioAAAGkFgAAAvf7A
Message-ID: <496565EC904933469F292DDA3F1663E602CBDD3777@dlee06.ent.ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
 <1277942401-3566-5-git-send-email-x0095840@ti.com>
 <1277942401-3566-6-git-send-email-x0095840@ti.com>
 <8F7AF80515AF0D4D93307E594F3CB40E4CA563BC@dlee03.ent.ti.com>
 <496565EC904933469F292DDA3F1663E602CBDD373C@dlee06.ent.ti.com>
 <8F7AF80515AF0D4D93307E594F3CB40E4CA5645D@dlee03.ent.ti.com>
In-Reply-To: <8F7AF80515AF0D4D93307E594F3CB40E4CA5645D@dlee03.ent.ti.com>
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
> From: Kanigeri, Hari
> Sent: Thursday, July 01, 2010 1:04 PM
> To: Guzman Lugo, Fernando; linux-omap@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: ohad@wizery.com; Hiroshi DOYU; ameya.palande@nokia.com;
> felipe.contreras@nokia.com
> Subject: RE: [PATCHv3 5/9] dspbridge: add mmufault support
> 
> > > > +	da = iommu_read_reg(mmu, MMU_FAULT_AD);
> > > > +	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
> > >
> > > -- Isn't the MMU already enabled at this point when the function
> > callback
> > > is called by iommu ?
> >
> > This line is actually disabling the interrupts. I am writing "0x0" in
> the
> > MMU_IRQENABLE.
> 
> -- oops ! sorry about that. Didn't pay attention to 0x0. Yes, this should
> work.

Not problem :). Could you please comment in the second set of patches I sent? The previous ones have version 3 which is not correct, that was a version I was using internally, but the patches shouldn't have sent to mailing list with that version. Because it is the first version posted.

Thanks and regards,
Fernando.

> 
> Best regards,
> Hari
