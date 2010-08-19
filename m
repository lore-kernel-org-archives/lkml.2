Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0HSVhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:37:04 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:29603
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab0HSVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:37:02 -0400
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4C6DA3E7.20206@freescale.com>
Date: Thu, 19 Aug 2010 16:36:39 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100402 Fedora/2.0.4-1.fc13 SeaMonkey/2.0.4
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
CC: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net,
        alsa-devel mailing list <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] of/device: Replace struct of_device with struct of_platform
References: <20100801074831.1099.3318.stgit@angua> <AANLkTiny_N-UqzuVaftLj75e_b0PjsdHstH8ZKx5mw7O@mail.gmail.com> <AANLkTi=12oe7hquDJ4NN_S=cFdfndfxxkOmzqPziD2CE@mail.gmail.com>
In-Reply-To: <AANLkTi=12oe7hquDJ4NN_S=cFdfndfxxkOmzqPziD2CE@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2010 21:36:39.0657 (UTC) FILETIME=[9BA60D90:01CB3FE6]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Thu, Aug 19, 2010 at 2:36 PM, Timur Tabi <timur@freescale.com> wrote:
>> On Sun, Aug 1, 2010 at 2:57 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>>>  sound/soc/fsl/mpc8610_hpcd.c                  |    4 +-
>>
>> This file is/was significantly rewritten for 2.6.37.  I posted a fix
>> to the alsa mailing list, but it will conflict with your patch.  You
>> might want to remove all changes to sound/soc/fsl from this commit.
> 
> This change is already in Linus' tree.

Then I suspect the ALSA guys are going to have a merge conflict coming up,
because I had to make these changes to the -next branch.


