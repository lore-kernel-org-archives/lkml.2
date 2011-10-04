Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab1JDVkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 17:40:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59664 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab1JDVku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 17:40:50 -0400
Message-ID: <4E8B7D3D.9000204@ti.com>
Date: Tue, 4 Oct 2011 23:40:13 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "Hilman, Kevin" <khilman@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [RFC 2/5] ARM: OMAP: omap_device: add a method to set iommu private
 archdata
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <1316948337-7924-3-git-send-email-ohad@wizery.com> <87sjni9aql.fsf@ti.com> <CAK=WgbZhz8LcAYZEY3qqRkX4E_wtspWp09Eq9G=5VdpoMMF1FQ@mail.gmail.com> <87botwk4gw.fsf@ti.com> <CAK=WgbYaEPBUz_J11+f+W+G9uUG3E6aQ-5=X9bj2nRhij-w-Sw@mail.gmail.com>
In-Reply-To: <CAK=WgbYaEPBUz_J11+f+W+G9uUG3E6aQ-5=X9bj2nRhij-w-Sw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2011 9:54 PM, Ohad Ben-Cohen wrote:
> On Tue, Oct 4, 2011 at 8:15 PM, Kevin Hilman<khilman@ti.com>  wrote:
>> The approach is OK with me, but I'm a bit torn about whether or not to
>> merge this since the need for this should go away when converting to DT.
>
> I guess it will still take some time until our boards are fully
> functional with DT, so I think we should regard this as an interim
> solution. Without this patch, a huge deal of code consolidation and
> generalization is gated (namely - generic iommu and dma api, and
> everything that depends on it, e.g. rpmsg/remoteproc).
>
>> Is anyone working on IOMMU DT description?
>
> Unless Benoit is, I'll happily pick this up.

Cool, a volunteer... You're in.

Thanks,
Benoit

