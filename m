Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1C3N3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:29:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab1C3N3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:29:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Linn <John.Linn@xilinx.com>
Subject: Re: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Date: Wed, 30 Mar 2011 15:29:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com
References: <1301444651-18008-1-git-send-email-john.linn@xilinx.com> <201103301344.45307.arnd@arndb.de> <f4872ed7-b6e4-4050-9445-5176f5aa961a@VA3EHSMHS017.ehs.local>
In-Reply-To: <f4872ed7-b6e4-4050-9445-5176f5aa961a@VA3EHSMHS017.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301529.03648.arnd@arndb.de>
X-Provags-ID: V02:K0:Jc7IKe3kOamKZk0a+sBgx38s3UPDI73goEi4FHh1H5C
 K6OldTP1p+5sENBTXW5RkjHqpX48G11SWv8EY4UFkjOp+8Q1G3
 VBRegJkxwasezsv4w17IHLxJTtvheFAuA3xcoycR5uSrFsB+Cv
 HIvknzzpxRkqWlMwiat/yhBYLm8gbCmvgXAmIA+5q5uPWPpZd2
 ixMoMEIpyQK/oTFALLjWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, John Linn wrote:
> Yes that makes sense.  We don't have immediate plans for PCI and 
> I was assuming when we add PCI we would need to change that.  
> 
> If you think I shouldn't put it off then I'll fix it now.  My 
> preference was to get the platform supported, then add more features.

Getting it fixed properly depends a bit on the PCI implementation.
I've been planning to clean up this part of the ARM architecture
for some time and I can probably do it for one more platform when
I get to it.

My idea for the multiplatform kernel is to have a global I/O space
window (maybe 1 MB) that is in the same location in the virtual
address space all the time, so any platform that wants to support
PCI with direct-mapped I/O space can simply map it in there
at boot time.

	Arnd
