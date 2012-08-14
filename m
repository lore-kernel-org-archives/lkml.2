Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab2HNNVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:21:02 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:39724 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2HNNVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:21:00 -0400
Message-Id: <502A6CD5020000A10000BADA@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 14 Aug 2012 15:20:53 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: "Borislav Petkov" <bp@alien8.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Antw: Re: Q: Seeing the microcode revision in /proc/cpuinfo
References: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
 <20120814131211.GA25921@x1.osrc.amd.com>
In-Reply-To: <20120814131211.GA25921@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

probably my edge is not bleeding that much than yours ;-)

I don't see "microcode" in 3.0.34-0.7-default for an AMD Opteron, and not in  2.6.32.59-0.3-default for the Intel Xeon. Both are kernels of SLES11 xon x86_64. The first one is the latest you can get for SLES11 SP2.

In openSUSE 12.1 (kernel 3.1.10) it's also still missing.

Anyway, it's nice to see that others also thought this feature is useful.

Thanks & best regards,
Ulrich

>>> Borislav Petkov <bp@alien8.de> schrieb am 14.08.2012 um 15:12 in Nachricht
<20120814131211.GA25921@x1.osrc.amd.com>:
> On Tue, Aug 14, 2012 at 02:35:40PM +0200, Ulrich Windl wrote:
> > Hi!
> > 
> > After several reboots due to memory errors after excellent power-saving of 
> Linux on a HP DL380G7 with Intel Xeon 5650 processors (all in on memory 
> bank), I found out the errate "BD104" and "BD123". The former should be fixed 
> in a microcode revision "15H".
> > 
> > Now I wonder what microcode revision my CPUs currently have. /proc/cpuinfo 
> doesn't show that, and the microcode update is a bit cryptic:
> > 
> > kernel: [   44.422912] microcode: CPU23 sig=0x206c2, pf=0x1, revision=0x14
> > 
> > Does that mean the revision is 0x14 BEFORE or AFTER the microcode update?
> > 
> > Wouldn't you agree that seeing the microcode revision in /proc/cpuinfo 
> would be nice?
> 
> Well, you must be using an old-ish kernel because the microcode revision
> infact *is* in /proc/cpuinfo:
> 
> processor       : 1
> ...
> stepping        : 0
> microcode       : 0x5000028
> 
> This is on 3.6-rc1 and that functionality is upstream since 3.2.
> 
> HTH.
> 
> -- 
> Regards/Gruss,
> Boris.
> 

 
 

