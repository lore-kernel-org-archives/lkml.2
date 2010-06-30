Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0F3Sog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:44:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47726 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0F3Soe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:44:34 -0400
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       "siccegge@cs.fau.de" <siccegge@cs.fau.de>
CC: "tony@atomide.com" <tony@atomide.com>,
       "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vamos@i4.informatik.uni-erlangen.de" 
	<vamos@i4.informatik.uni-erlangen.de>
Date: Wed, 30 Jun 2010 13:44:14 -0500
Subject: RE: [PATCH 22/33] Removing dead MPU_{BRIDGE,TESLA}_IOMMU
Thread-Topic: [PATCH 22/33] Removing dead MPU_{BRIDGE,TESLA}_IOMMU
Thread-Index: AcsYgWoI3iWF+krYSEyLfcx8ervh7gAAlHVA
Message-ID: <8F7AF80515AF0D4D93307E594F3CB40E4CA55915@dlee03.ent.ti.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<fcfa44a43c21c70f89ced96b96d7c1489d28cc51.1277911346.git.siccegge@cs.fau.de>
 <20100630.212346.226780589.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20100630.212346.226780589.Hiroshi.DOYU@nokia.com>
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
> Sent: Wednesday, June 30, 2010 1:24 PM
> To: siccegge@cs.fau.de; Kanigeri, Hari
> Cc: tony@atomide.com; linux@arm.linux.org.uk; linux-omap@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> vamos@i4.informatik.uni-erlangen.de
> Subject: Re: [PATCH 22/33] Removing dead MPU_{BRIDGE,TESLA}_IOMMU
> 
> From: ext Christoph Egger <siccegge@cs.fau.de>
> Subject: [PATCH 22/33] Removing dead MPU_{BRIDGE,TESLA}_IOMMU
> Date: Wed, 30 Jun 2010 18:01:01 +0200
> 
> > MPU_{BRIDGE,TESLA}_IOMMU doesn't exist in Kconfig, therefore removing
> > all references for it from the source code.
> 
> Coming soon, I guess. Hari?

Coming soon for both Bridge and Tesla. As I am writing this email, Fernando is preparing the Bridge patches to migrate to iommu.

Thank you,
Best regards,
Hari
