Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0HXTFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:05:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0HXTFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:05:16 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Tue, 24 Aug 2010 14:05:13 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActDveHcPkKL5eXsQbyO/EpIjkWjwAAAOygA
Message-ID: <496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
	<1277943660-4112-3-git-send-email-x0095840@ti.com>
	<1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
	<1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
	<AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA397F@dlee06.ent.ti.com>
 <AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
In-Reply-To: <AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
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
> Sent: Tuesday, August 24, 2010 1:55 PM
> To: Guzman Lugo, Fernando
> Cc: Kanigeri, Hari; linux-omap@vger.kernel.org; 
> linux-kernel@vger.kernel.org; ohad@wizery.com; 
> hiroshi.doyu@nokia.com; ameya.palande@nokia.com; 
> felipe.contreras@nokia.com
> Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
> 
> On Tue, Aug 24, 2010 at 9:44 PM, Guzman Lugo, Fernando 
> <fernando.lugo@ti.com> wrote:
> >> However, I still have the question about the dependency on iommu; 
> >> AFAICS the DMM removal doesn't depend on the migration to iommu, 
> >> which AFAIK has been stalled for some time.
> >
> > Yeah, DMM removal does not depend on iommu migration. 
> However, After 
> > the changes for iommu migration the DMM module is not 
> Needed anymore, 
> > so it is better to remove it too.
> 
> Yes, but there are two options:
> 
> a) 1. Migrate to iommu, 2. Remove DMM
> 
> or:
> 
> b) 1. Remove DMM, 2. Migrate to iommu
> 
> I've heard there are some problems regarding DMM, and since 
> you say you have already done the changes, and since iommu 
> migration is not yet ready AFAIK, it might make sense to go 
> for option b).
> 
> Anyway, thanks for the clarification :)

But DMM is used in this momment, it is after the IOMMU migration
When DMM is not needed anymore. So we need to go for option a).

Regards,
Fernando.

> 
> --
> Felipe Contreras
> 