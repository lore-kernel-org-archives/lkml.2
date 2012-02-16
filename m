Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2BPPst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:48:49 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:43315 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2BPPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:48:48 -0500
Message-ID: <4F3D2553.9010600@free-electrons.com>
Date: Thu, 16 Feb 2012 16:48:35 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
CC: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, tony@atomide.com,
        s.hauer@pengutronix.de, magnus.damm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ARM: add xz kernel compression support
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com> <4F3D22D5.3060607@bluegiga.com>
In-Reply-To: <4F3D22D5.3060607@bluegiga.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Veli,

On 02/16/2012 04:37 PM, Veli-Pekka Peltola wrote:
> Hi,
>
> On 02/16/2012 04:54 PM, Michael Opdenacker wrote:
>> It adds xz support to the ARM tree. x86 already has it, so let's
>> have it too!
>
> XZ support is already applied to Russell's for-next through patch
> tracking system [1].
>
> [1]:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7001/2

Cool! Good to know that we already have this :-)
This was a good exercise anyway and not a complete waste of time as I
produced benchmarks in the process.

Thanks,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+33 484 253 396

