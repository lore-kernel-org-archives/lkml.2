Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2BPQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:03:24 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:43489 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2BPQDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:03:23 -0500
Message-ID: <4F3D28BE.7070601@free-electrons.com>
Date: Thu, 16 Feb 2012 17:03:10 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: nicolas.pitre@linaro.org, tony@atomide.com, s.hauer@pengutronix.de,
        magnus.damm@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: ARM: add xz kernel compression support
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com> <20120216155507.GO13673@n2100.arm.linux.org.uk>
In-Reply-To: <20120216155507.GO13673@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 04:55 PM, Russell King - ARM Linux wrote:
> On Thu, Feb 16, 2012 at 03:54:15PM +0100, Michael Opdenacker wrote:
>> This patchset applies on Linus' tree
>>
>> It adds xz support to the ARM tree. x86 already has it, so let's have it too!
>> My benchmarks below show that xz is better than lzma in terms of image size
>> and uncompression time.
> Have you checked what's in my tree?  Have you checked patch 7001/2 ?
No, I haven't. Promise to do my homework better next time ;-)
Thanks for your time anyway.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+33 484 253 396

