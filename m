Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0EDOG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:06:27 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:52064
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932383Ab0EDOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:06:24 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM4015L62a3Lzz1202hzz6ff19hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1WF1R-01-HV7-02
X-M-MSG: 
Date: Tue, 4 May 2010 16:03:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: John Villalovos <sodarock@gmail.com>
CC: andi@firstfloor.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       oprofile-list@lists.sf.net
Subject: Re: [PATCH] Oprofile: Change CPUIDS from decimal to hex, and add
 some comments
Message-ID: <20100504140328.GB6450@erda.amd.com>
References: <20100416170849.GA15932@linuxjohn.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100416170849.GA15932@linuxjohn.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.04.10 13:08:49, John Villalovos wrote:
> Back when the patch was submitted for "Add Xeon 7500 series support to
> oprofile", Robert Richter had asked for a follown patch that converted
> all the CPU ID values to hex.
> 
> I have done that here for the processors in the ppro_init() function and also
> added some documentation as comments that I retrieved from the Intel Software
> Developer's Manual (SDM) March 2010 edition in Volume 3B, Table B-1.
> 
> The Intel SDM can be found at:
> http://www.intel.com/products/processor/manuals/
> 
> I also added processor codenames for some of the newer processors.

John,

I don't want to change previous cpu models and keep it as it is. So I
am fine with updating i386/core_i7 and i386/atom to avoid mixed dec
and hex notations.

Please also remove the comments that describe the model as it will be
hard to maintain this, if there are questions one should read the
spec. So please also add some more details of the specification source
to the patch description, I think it is:

 Table B-1. CPUID Signature Values of DisplayFamily_DisplayModel

in SDM Volume 3B.

Use lower case hex values instead.

Add your Signed-off-by please.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

