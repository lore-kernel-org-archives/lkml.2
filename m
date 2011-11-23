Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1KWU2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:28:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27142 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1KWU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:28:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6539"; a="138109248"
Message-ID: <4ECD5767.90307@codeaurora.org>
Date: Wed, 23 Nov 2011 12:28:23 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
References: <1319536106-25802-1-git-send-email-ohad@wizery.com> <4ECC67B9.4050306@codeaurora.org> <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com> <20111123161012.GA31423@sirena.org.uk>
In-Reply-To: <20111123161012.GA31423@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 08:10 AM, Mark Brown wrote:
> On Wed, Nov 23, 2011 at 12:27:31PM +0200, Ohad Ben-Cohen wrote:
>> On Wed, Nov 23, 2011 at 5:25 AM, Saravana Kannan<skannan@codeaurora.org>  wrote:
>
>>> Sorry for the rant, this naming just rubs me the wrong way. I definitely
>>> appreciate the idea behind these patches.
>
>> I don't share the same naming concerns you have (if any, then
>> confusion with the bluetooth AMP patches and prefixes is more of a
>> concern to me), but I don't care deeply about names.
>
> I guess one very real potential for confusion here is the big/little
> stuff that ARM are pushing for next generation SoCs where a Linux image
> does actually run on muliple asymmetric cores.
>
>> Feel free to offer a different name, though really 'amp' here only
>> describes the general model and motivation and is rarely used
>> throughout the code; we mostly either use 'remoteproc' or 'rpmsg',
>> which respectively refer to the two frameworks that are being added
>> (the former responsible for controlling the state of the remote
>> processors, and the latter for communicating with them).
>
> How about using remoteproc then?

remoteproc, peripheral proc, device proc, firmware proc (kinda lines up 
with request_firmware naming). Just throwing out names. Any one of these 
are okay with me.

remoteproc would probably be the best fit since it's already used in the 
code and people are used to discussing about it.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
