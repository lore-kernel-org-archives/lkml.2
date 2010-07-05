Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0GEGTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 02:19:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:60125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0GEGTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 02:19:32 -0400
Message-ID: <4C31796C.8050209@kernel.org>
Date: Mon, 05 Jul 2010 08:19:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Stan Hoeppner <stan@hardwarefreak.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F87C1.8000701@hardwarefreak.com>	<AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>	<4C2F9292.708@hardwarefreak.com>	<AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com> <AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
In-Reply-To: <AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Jul 2010 06:19:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/04/2010 12:31 AM, Mark Knecht wrote:
> OK, I don't know if this is related but so far I cannot get the
> machine to boot if I set BIOS SATA configuration to AHCI. I believe
> that I have AHCI support as well as SATA support built into the kernel
> but when I set the BIOS to AHCI the machine just hangs saying it finds
> no medium. I assume that means no hard drive. I have to set SATA
> support to enhanced and then IDE to get the machine to boot at all.

That's odd.  Can you please attach kernel boot log w/ ahci mode?
Booting a recent live CD and saving boot log from there should do the
trick.

Thanks.

-- 
tejun
