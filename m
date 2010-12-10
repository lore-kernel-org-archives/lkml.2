Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0LJJpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 04:45:40 -0500
Received: from mail.atmel.fr ([81.80.104.162]:51538 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0LJJpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 04:45:38 -0500
Message-ID: <4D01F6BC.1070401@atmel.com>
Date: Fri, 10 Dec 2010 10:45:32 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christian Glindkamp <christian.glindkamp@taskit.de>
CC: Igor Plyatov <plyatov@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>,
        linux@arm.linux.org.uk, costa.antonior@gmail.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        pgsellmann@portner-elektronik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: Refactor Stamp9G20 and PControl G20 board file
References: <4CFFE5A9.4040407@bluewatersys.com> <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de> <1291909193.6251.32.camel@homepc> <20101210084400.GA24295@taskit.de>
In-Reply-To: <20101210084400.GA24295@taskit.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/12/2010 09:44, Christian Glindkamp :
> On 2010-12-09 18:39, Igor Plyatov wrote:
>> Dear Christian,
>>
>>> As PControl G20 is a carrier board for the Stamp9G20 SoM, some code can
>>> be shared. Therefore board-stamp9g20.c is refactored to allow reusing the
>>> SoM initialization and board-pcontrol-g20.c is modified to use it.
>>>
>>> Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
>>> ---
>>>
>>> How about this approach? Compile tested for PControl G20 and run time tested
>>> for Stamp9G20 EVB and PortuxG20.
>>>
>>> Just a side note: PortuxG20 is not a carrier board for the Stamp9G20. It just
>>> shares so much with the evaluation board, that it makes sense to put them both
>>> into the same file. And there is no intention to put other boards into this
>>> file.
>>
>> The idea from this patch is clean.

Seems clean to me also.

>> Yours patch does not apply to the kernel from
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git,
>> but I apply its content by hands and kernels compiled successfully with
>> stamp9g20_defconfig and pcontrol_g20_defconfig.
> 
> I used exactly this repository. Revision 6313e3c21743cc88bb5bd8aa72948ee1e83937b6
> to be precise. Maybe your mailer corrupted the patch.
> 
>> Please run ./scripts/checkpatch.pl with you patch and correct all errors
>> and warnings reported. 
> 
> I only get some "line over 80 characters" warnings, which can imho be
> ignored.
> 
>>
>> If you will correct this patch, to be applicable, then I will vote to
>> include it into mainline.
>>
>> Which kernel repository and branch should I use for the AT91 ARM?
>> I just want to know - whereto send my next patch to support gms machine?

You can build your "gms" patch on top of Linus' + Christian's patches.

Then, I will:
- send the patch series to mailing-list for final review (maybe with one
or two additional patches)
- prepare a pull-request for inclusion in mainline (.37-final may be ok
as it is just board additions)

Bye,
-- 
Nicolas Ferre
