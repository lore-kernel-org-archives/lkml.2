Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2BPLFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:05:34 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:40655 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2BPLFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:05:33 -0500
Message-ID: <4F3CE2EF.60709@free-electrons.com>
Date: Thu, 16 Feb 2012 12:05:19 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: nicolas.pitre@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: boot/compressed/decompress.c cleanup
References: <1329370449-12033-1-git-send-email-michael.opdenacker@free-electrons.com> <20120216085010.GI13673@n2100.arm.linux.org.uk>
In-Reply-To: <20120216085010.GI13673@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Thank you for reviewing my patch.

On 02/16/2012 09:50 AM, Russell King - ARM Linux wrote:
> On Thu, Feb 16, 2012 at 06:34:09AM +0100, Michael Opdenacker wrote:
>> - Remove the ARCH_HAS_DECOMP_WDOG define
>>   because it is only used in lib/deflate.c, which
>>   only the alpha architecture uses. No other architecture
>>   uses this define
> No.  Your grepping is broken.
Oops, my mistake. Actually, only arm uses this feature.

I'll soon post an updated patch.

Thanks again,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+33 484 253 396

