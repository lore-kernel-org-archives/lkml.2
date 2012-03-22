Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab2CVOLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:11:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54272 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2CVOLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACKLOr03tTymT1vdTH7=nqEHu3OvAinPUHEusK+mR+J6Yc35mQ@mail.gmail.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
	<1332344363.19804.12.camel@vkoul-udesk3>
	<CACKLOr03tTymT1vdTH7=nqEHu3OvAinPUHEusK+mR+J6Yc35mQ@mail.gmail.com>
Date: Thu, 22 Mar 2012 15:11:52 +0100
Message-ID: <CACKLOr0JTgp+poXCNg8+8pXko3s2JWQhovMw8Z1j-q4aL4oaKQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2012 10:39, javier Martin <javier.martin@vista-silicon.com> wrote:
> On 21 March 2012 16:39, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>> On Fri, 2012-03-09 at 16:20 +0100, Javier Martin wrote:
>>> The following series have to be applied on top of the following patches:
>>> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
>>> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
>>>
>>> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
>>> is deprecated and no new patches are accepted for it.
>>>
>>> This series merges this code into the imx-dma.c dmaengine driver.
>>>
>>> Notes for v3:
>>>  - I send the whole series again despite some patches being the same. I think
>>>  this is more comfortable for Vinod than just sending those patches that have
>>>  been modified.
>>>  - I've generated my series with the following command this time:
>>>  'git format-patch -s -13 -M -B --subject-prefix="PATCH v3"' as suggested by
>>>  Sascha but still removing two files in 01/13 generates a lot of noisy diffs.
>>>  Sorry about that.
>>>  - I don't include Sascha's Tested-by since maybe he wants to test this last
>>>  version.
>> This doesn't apply for me (starting with 6th) on current slave-dma.next
>> due to obvious changes which have gone into imx.
>>
>> Can you quickly rebase the series and resend.
>
> Great,
> now your 'next' branch is actually broken for imx-dma.
>
> I'm currently trying a bisect to find out what is the commit
> responsible for that but I suspect it will be related to the cookie
> changes submitted by Russell.

Here,
take a look at this series:

[PATCH v4 00/15] dmaengine: imx-dma: rebase of features for 3.4.

I've included a new fix patch which solves the merge issue.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
