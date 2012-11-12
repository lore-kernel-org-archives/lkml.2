Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2KLSkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:40:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60120 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2KLSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:40:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=WgbYR8UMyDjySJLRC0tEbJO3FaFgjWxceNwMyVdMgEgwPig@mail.gmail.com>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
	<CAK=WgbYR8UMyDjySJLRC0tEbJO3FaFgjWxceNwMyVdMgEgwPig@mail.gmail.com>
Date: Mon, 12 Nov 2012 12:40:06 -0600
Message-ID: <CALLhW=5WNg8X0nX8U+AExocyNKW=wJ7oS36xg4ENMnfyJkX8RQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Move rest of omap-iommu to live in drivers/iommu
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11 November 2012 03:39, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Fri, Nov 2, 2012 at 9:23 PM, Tony Lindgren <tony@atomide.com> wrote:
>> We need to move the iommu code to live under drivers
>> for arm common zImage support.
>
> For the iommu changes in the entire series:
>
> Acked-by: Ohad Ben-Cohen <ohad@wizery.com>
>
> Joerg, it might relieve some pain if this will go through Tony's tree,
> as there are some OMAP platform iommu changes coming in from Omar as
> well (part of which might have already been merged in the omap
> branches). Hope it's ok with both of you guys?
>
> Omar, do you still have any iommu changes coming in ?

Yes, I have the hwmod and runtime pm changes for iommu, I was waiting
for Tony to publish a branch with these changes to submit (as per
Tony's suggestion), but I already have the patches rebased onto these.

I will submit them.

Cheers,

Omar
