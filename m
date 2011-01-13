Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1AMFuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:50:19 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:49763 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1AMFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:50:17 -0500
Message-ID: <4D2E928D.9030208@ahsoftware.de>
Date: Thu, 13 Jan 2011 06:50:05 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@fluxnic.net>, Dave Martin <dave.martin@linaro.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: relocation out of range (when loading a module)
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home> <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk> <4D2D1942.4050905@ahsoftware.de> <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com> <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk>
In-Reply-To: <20110112184258.GH11039@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 12.01.2011 19:42, schrieb Russell King - ARM Linux:

> As the overall feeling at the time was "don't use large initrds" it's
> something I've never really cared about - and I'm still of the opinion
> that 16MB of compressed initrd/initramfs is rather silly.

Hmm, sorry, I have to disagree. ;)
E.g. 12MB out of the 16MB in the initramfs I've used are modules.
I've also created some larger initramfs wich included  X11 and such, and 
I find it very convenient to use the initramfs to include a rootfs in 
the the kernel and so only have to handle one file for all. E.g. just 
load the kernel with the included rootfs via tftp and you are done.

Sure this can all be done using an external initrd, but that is much 
less comfortable to use.

At least I like that feature since it is available and won't miss it now. ;)

Regards,

Alexander
