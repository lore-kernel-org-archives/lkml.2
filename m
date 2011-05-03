Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1ECUsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:48:12 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51703 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124Ab1ECUsL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <201105032218.29592.arnd@arndb.de>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
	<201105032218.29592.arnd@arndb.de>
Date: Tue, 3 May 2011 15:48:07 -0500
Message-ID: <BANLkTin7vsfjF+86UrGb7ph0B8TpiXiF0A@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] staging tidspbridge: iommu migration
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>, devel <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, May 3, 2011 at 3:18 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 28 April 2011 17:31:46 Omar Ramirez Luna wrote:
>> Rework and rebase of the previous set of patches for iommu migration[1].
>>
>> Reorganized the patches to avoid several iterations to change the same code.
>>
>> Patches were tested with an OMAP3630 board, with both, basic samples and
>> gst-dsp; these are dependant on patch:
>>         "OMAP: iovmm: fix SW flags passed by user"[2].
>
> The code removal in this series looks good, but the move from
> one proprietary iommu API to another proprietary iommu API
> seems pointless.
>
> It would be much more helpful if you could convert the tidspbridge
> code to the dma-mapping API, or to the generic iommu API
> and provide these interfaces from the omap code.

Yes, I thought removing a bunch of lines from staging might be good.
I'll check what can be done to use generic iommu or dma-mapping.

Thanks,

Omar
