Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab1JDU3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:29:10 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54476 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933114Ab1JDU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:29:09 -0400
From: Kevin Hilman <khilman@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [RFC 2/5] ARM: OMAP: omap_device: add a method to set iommu private archdata
Organization: Texas Instruments, Inc.
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
	<1316948337-7924-3-git-send-email-ohad@wizery.com>
	<87sjni9aql.fsf@ti.com>
	<CAK=WgbZhz8LcAYZEY3qqRkX4E_wtspWp09Eq9G=5VdpoMMF1FQ@mail.gmail.com>
	<87botwk4gw.fsf@ti.com>
	<CAK=WgbYaEPBUz_J11+f+W+G9uUG3E6aQ-5=X9bj2nRhij-w-Sw@mail.gmail.com>
Date: Tue, 04 Oct 2011 13:29:03 -0700
In-Reply-To: <CAK=WgbYaEPBUz_J11+f+W+G9uUG3E6aQ-5=X9bj2nRhij-w-Sw@mail.gmail.com>
	(Ohad Ben-Cohen's message of "Tue, 4 Oct 2011 21:54:44 +0200")
Message-ID: <87mxdga4c0.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:

> On Tue, Oct 4, 2011 at 8:15 PM, Kevin Hilman <khilman@ti.com> wrote:
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

tag.  you're it.

>> I guess if I do merge this, we can also clean this up significantly
>> after all devices are converted to DT.
>
> Sure.

OK, as long as I have some confidence that this is going in the right
direction (and having you on the job is a good sign!)  I'm willing to
merge something like this as an interim solution.

Kevin

>> Unless it has other dependencies on Benoit's further DT patches, you can
>> base this on my for_3.2/omap_device-2 branch which includes Benoit's
>> alloc changes.
>
> Ok, thanks a lot !
> Ohad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
