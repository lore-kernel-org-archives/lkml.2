Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2HNNb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:31:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40722 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab2HNNb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:31:26 -0400
Date: Tue, 14 Aug 2012 15:31:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Antw: Re: Q: Seeing the microcode revision in /proc/cpuinfo
Message-ID: <20120814133140.GB25921@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
	linux-kernel@vger.kernel.org
References: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
 <20120814131211.GA25921@x1.osrc.amd.com>
 <502A6CD5020000A10000BADA@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <502A6CD5020000A10000BADA@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 03:20:53PM +0200, Ulrich Windl wrote:
> Hi Borislav,
> 
> probably my edge is not bleeding that much than yours ;-)
> 
> I don't see "microcode" in 3.0.34-0.7-default for an AMD Opteron, and not in  2.6.32.59-0.3-default for the Intel Xeon. Both are kernels of SLES11 xon x86_64. The first one is the latest you can get for SLES11 SP2.
> 
> In openSUSE 12.1 (kernel 3.1.10) it's also still missing.
> 
> Anyway, it's nice to see that others also thought this feature is useful.

Yep,

those are all before 3.2.

Well, if you still want to find out the microcode revision on those
boxes, on both AMD and Intel you can do as root:

$ rdmsr 0x8b

You need the msr.ko kernel module loaded or built-in (CONFIG_X86_MSR
option enabled) for this and rdmsr is from the msr-tools package.

HTH.

-- 
Regards/Gruss,
Boris.
