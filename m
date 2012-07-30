Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2G3MiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:38:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48252 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab2G3MiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:38:10 -0400
MIME-Version: 1.0
In-Reply-To: <CACKLOr1dLkVwy4YPMfCGL-GzLZT8BfdFmujeqUPO=xwJ73Xt1A@mail.gmail.com>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
	<1343359050.1726.9033.camel@vkoul-udesk3>
	<CAOMZO5DCEgjw1cyCV5nP-aoksboF2HFQ_emzSUXRCgGAGNuqUg@mail.gmail.com>
	<CACKLOr1dLkVwy4YPMfCGL-GzLZT8BfdFmujeqUPO=xwJ73Xt1A@mail.gmail.com>
Date: Mon, 30 Jul 2012 14:38:09 +0200
Message-ID: <CACKLOr1BHZR+d8UwSCtnEhO=CnrmGBsD8Tt_KtrBCmWEvE4Z=Q@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: Fix kernel crash due to missing clock conversion
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 July 2012 13:31, javier Martin <javier.martin@vista-silicon.com> wrote:
> Hi,
>
> On 27 July 2012 13:37, Fabio Estevam <festevam@gmail.com> wrote:
>> On Fri, Jul 27, 2012 at 12:17 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>>
>>>> Reported-by: Javier Martin <javier.martin@vista-silicon.com>
>>>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>>> Applied thanks (to fixes-for 3.7)
>>
>> You mentioned that you would also copy stable. Would it be applied
>> into stable soon too?
>
> I agree with Fabio, this patch should also be applied to stable.
>
> Regards.

I almost forgot,
Vinod, I am a bit confused about the branch you've used to merge this
patch. The branch is called 'fixes_for-3.7'. Does this mean that the
patch won't be applied for 3.6? I've seen you've added the line ' Cc:
stable@vger.kernel.org' which ensures the patch will appear in 3.5.X
but what about 3.6?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
