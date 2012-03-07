Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2CGJZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:25:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CGJZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:25:19 -0500
MIME-Version: 1.0
In-Reply-To: <1331108158.24656.330.camel@vkoul-udesk3>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
	<1330964196-32623-2-git-send-email-javier.martin@vista-silicon.com>
	<1331102571.24656.324.camel@vkoul-udesk3>
	<CACKLOr0iBSMd8hNdmeAiMWgyyUb_b1=5n47N97hu9EP2Zu9OsQ@mail.gmail.com>
	<1331108158.24656.330.camel@vkoul-udesk3>
Date: Wed, 7 Mar 2012 10:25:19 +0100
Message-ID: <CACKLOr1VHkLeCnUDcOEuBBjN5iY72ADvqXoNk0NR_N95fkd6Kg@mail.gmail.com>
Subject: Re: [PATCH 01/14] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        dan.j.williams@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2012 09:15, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, 2012-03-07 at 08:52 +0100, javier Martin wrote:
>> Hi Vinod,
>>
>> On 7 March 2012 07:42, Vinod Koul <vinod.koul@intel.com> wrote:
>> > On Mon, 2012-03-05 at 17:16 +0100, Javier Martin wrote:
>> > Sascha,
>> > Are there any more users of dmac in mach-imx?
>>
>> No, there are no other users of mach-imx. In fact, it was Sascha's
>> idea to make this merge [1].
> Then please move the file in 1st patch, also it would be easily clear
> what parts are added, deleted and moved.

All right, I will, but I'll wait for Sascha and others to comment on
the series too.

> Otherwise the series looks fine except that it needs to have a better
> changelog on why you are removing certain field/struct. It helps to
> document the motivation of doing certain change, you will find that you
> wont remember that six months down the line :)

Thanks for the suggestion, I'll rewrite my changelogs.

> Also I am looking for Tested-By from people who have use imx-dma.

That would be awesome. I've tested this series with a test battery which covers:
- mxcmmc
- audio
- dmatest module


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
