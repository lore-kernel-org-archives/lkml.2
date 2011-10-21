Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1JUQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:52:20 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50753 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408Ab1JUQwT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <65EE16ACC360FA4D99C96DC085B3F7722AE773@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1319162083.4352.2.camel@phoenix>
	<65EE16ACC360FA4D99C96DC085B3F7722AE773@039-SN1MPN1-003.039d.mgd.msft.net>
Date: Fri, 21 Oct 2011 17:52:17 +0100
Message-ID: <CABS+qY0hOywM5D04crw9W_gPPHx8dZSSR1rSPiVU4WiagqoB3w@mail.gmail.com>
Subject: Re: [PATCH] ASoC: sgtl5000: Fix wrong mask in some
 snd_soc_update_bits calls
From: "Girdwood, Liam" <lrg@ti.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2011 08:36, Dong Aisheng-B29396 <B29396@freescale.com> wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Axel Lin
>> Sent: Friday, October 21, 2011 9:55 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Dong Aisheng-B29396; Wolfram Sang; Liam Girdwood; Mark Brown; alsa-
>> devel@alsa-project.org
>> Subject: [PATCH] ASoC: sgtl5000: Fix wrong mask in some
>> snd_soc_update_bits calls
>>
>> Ensure all mask bits are clear before setting new value.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>> I don't have this hardware, I'd appreciate if someone can test this patch.
>>
>> Thanks,
>> Axel
>>  sound/soc/codecs/sgtl5000.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> It runs ok at my side.
> Acked-by: Dong Aisheng <b29396@freescale.com>
>

Acked-by: Liam Girdwood <lrg@ti.com>
