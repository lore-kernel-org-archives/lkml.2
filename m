Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1GGPe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:34:56 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:14634 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1GGPex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:34:53 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzJuKyT2w==
X-RZG-CLASS-ID: mo00
Message-ID: <4E15D215.2010203@hartkopp.net>
Date: Thu, 07 Jul 2011 17:34:45 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ram Pai <linuxram@us.ibm.com>, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 3/5 v2] PCI: make SRIOV resources optional
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>	<1309477662-18680-4-git-send-email-linuxram@us.ibm.com>	<4E0D62BD.5070405@hartkopp.net> <20110706104848.7e9d21fc@jbarnes-desktop>
In-Reply-To: <20110706104848.7e9d21fc@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.07.2011 19:48, Jesse Barnes wrote:
> On Fri, 01 Jul 2011 08:01:33 +0200
> Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> 
>> On 01.07.2011 01:47, Ram Pai wrote:
>>> From: Yinghai Lu <yinghai@kernel.org>
>>>
>>> From: Yinghai Lu <yinghai@kernel.org>
>>>
>>> Allocate resources to SRIOV BARs only after all other required
>>> resource-requests are satisfied. Dont retry if resource allocation for SRIOV
>>> BARs fail.
>>>
>>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>
>> I applied the whole patchset and it looks very similar to the dmsg output
>> before the problematic commit that caused the regression.
> 
> Ok Oliver, can I ask you to test one more tree?  We'll shoot for
> including Ram's patches in -next, but I've just included his other
> patch to disable the new realloc code by default for the current
> kernel.  Can you give my for-linus tree a try and make sure it gives
> you back the old behavior?  Thanks a lot for your diligent testing so
> far.

I can confirm that it has the exact pci assignments as it had before.

I'll send you the dmesg output in a separate mail.

Best regards,
Oliver

> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 is the
> tree, then check out the "for-linus" branch.
> 
> Thanks,

