Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1FOQ6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:58:40 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:32516 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1FOQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:58:39 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/FuK2Ti/k=
X-RZG-CLASS-ID: mo00
Message-ID: <4DF8E4C7.6060303@hartkopp.net>
Date: Wed, 15 Jun 2011 18:58:47 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
References: <4DEBCA3F.8050205@hartkopp.net> <BANLkTin_WHuy5MExNBHdeLiDmdmn7SZYkg@mail.gmail.com> <4DED05C4.7050903@hartkopp.net> <m3hb82wx6m.fsf@pullcord.laptop.org> <4DEE6FC6.9040308@hartkopp.net> <4DEE84AD.6050104@hartkopp.net> <4DEEA3CD.30507@kernel.org> <4DEF1606.5030803@hartkopp.net> <20110612204406.GC30738@ram-laptop> <4DF8E083.1080006@hartkopp.net> <20110615165414.GA11421@ram-laptop>
In-Reply-To: <20110615165414.GA11421@ram-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.06.2011 18:54, Ram Pai wrote:
> On Wed, Jun 15, 2011 at 06:40:35PM +0200, Oliver Hartkopp wrote:
>> On 12.06.2011 22:44, Ram Pai wrote:

>>> Looks like the kernel; by default, tries to allocate mem resource of size
>>> 0x4000000 each to the BARs of the cardbus bridge. This cannot be satisfied
>>> meeting all the constraints. The BIOS had not allocated the resource to
>>> begin with.
>>>
>>> Anyone knows if the default value can be reduced to something smaller?
>>> Or Should the resource requirements of cardbus bridge be made nice-to-have?
>>
>> Don't know ...
>>
>> Is anyone already working on this issue?
>>
>> I'm currently running 3.0.0-rc3-00055-gada9c93 which still does not work.
>>
>> Will say: 'Send more patches!' ... that i can test, if you still like the
>> problematic commit's idea ;-)
> 
> Oliver,
> 
> 	Yes. I am working on this. I will send you a patch soon; probably by
> the end of this week. See if they work for you.
> 
> Currently my thought is to make cardbus-bridge resource allocation
> nice-to-have, which means it will be attempted to allocate. But if in case of
> failures, we wont go the full length of releasing other resources to satisfy
> this resource.

Thanks for your fast feedback. I'm looking forward to help you.

Best regards,
Oliver
