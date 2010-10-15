Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0JOMqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:46:15 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33515 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0JOMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:46:14 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0LAC0SR-01-5HU-02
X-M-MSG: 
Date: Fri, 15 Oct 2010 14:46:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Anand Gadiyar <gadiyar@ti.com>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] oprofile: include platform_device.h to fix build
 break
Message-ID: <20101015124604.GD5969@erda.amd.com>
References: <1287070303-32404-1-git-send-email-gadiyar@ti.com>
 <1287070303-32404-2-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287070303-32404-2-git-send-email-gadiyar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.10.10 11:31:43, Anand Gadiyar wrote:
> oprofile_perf.c needs to include platform_device.h
> Otherwise we get the following build break.
> 
>   CC      arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.o
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:192: warning: 'struct platform_device' declared inside parameter list
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:192: warning: its scope is only this definition or declaration, which is probably not what you want
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:201: warning: 'struct platform_device' declared inside parameter list
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:210: error: variable 'oprofile_driver' has initializer but incomplete type
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:211: error: unknown field 'driver' specified in initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:211: error: extra brace group at end of initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:211: error: (near initialization for 'oprofile_driver')
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:213: warning: excess elements in struct initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:213: warning: (near initialization for 'oprofile_driver')
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:214: error: unknown field 'resume' specified in initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:214: warning: excess elements in struct initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:214: warning: (near initialization for 'oprofile_driver')
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:215: error: unknown field 'suspend' specified in initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:215: warning: excess elements in struct initializer
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:215: warning: (near initialization for 'oprofile_driver')
> arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c: In function 'init_driverfs':
> 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Robert Richter <robert.richter@amd.com>

I applied both patches to the oprofile/core branch. Thanks Anand.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

