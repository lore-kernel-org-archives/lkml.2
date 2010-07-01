Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0GASEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:04:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44433 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0GASEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:04:14 -0400
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohad@wizery.com" <ohad@wizery.com>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 1 Jul 2010 13:04:08 -0500
Subject: RE: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Topic: [PATCHv3 5/9] dspbridge: add mmufault support
Thread-Index: AcsYr29geLDqkvcsTwW6nxBnghiRywAkS5RwAAFMioAAAGkFgA==
Message-ID: <8F7AF80515AF0D4D93307E594F3CB40E4CA5645D@dlee03.ent.ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
 <1277942401-3566-5-git-send-email-x0095840@ti.com>
 <1277942401-3566-6-git-send-email-x0095840@ti.com>
 <8F7AF80515AF0D4D93307E594F3CB40E4CA563BC@dlee03.ent.ti.com>
 <496565EC904933469F292DDA3F1663E602CBDD373C@dlee06.ent.ti.com>
In-Reply-To: <496565EC904933469F292DDA3F1663E602CBDD373C@dlee06.ent.ti.com>
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

> > > +	da = iommu_read_reg(mmu, MMU_FAULT_AD);
> > > +	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
> >
> > -- Isn't the MMU already enabled at this point when the function
> callback
> > is called by iommu ?
> 
> This line is actually disabling the interrupts. I am writing "0x0" in the
> MMU_IRQENABLE.

-- oops ! sorry about that. Didn't pay attention to 0x0. Yes, this should work.

Best regards,
Hari
