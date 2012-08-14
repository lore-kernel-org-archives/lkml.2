Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2HNNMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:12:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58639 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab2HNNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:11:59 -0400
Date: Tue, 14 Aug 2012 15:12:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: Seeing the microcode revision in /proc/cpuinfo
Message-ID: <20120814131211.GA25921@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
	linux-kernel@vger.kernel.org
References: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <502A623C020000A10000BACA@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:35:40PM +0200, Ulrich Windl wrote:
> Hi!
> 
> After several reboots due to memory errors after excellent power-saving of Linux on a HP DL380G7 with Intel Xeon 5650 processors (all in on memory bank), I found out the errate "BD104" and "BD123". The former should be fixed in a microcode revision "15H".
> 
> Now I wonder what microcode revision my CPUs currently have. /proc/cpuinfo doesn't show that, and the microcode update is a bit cryptic:
> 
> kernel: [   44.422912] microcode: CPU23 sig=0x206c2, pf=0x1, revision=0x14
> 
> Does that mean the revision is 0x14 BEFORE or AFTER the microcode update?
> 
> Wouldn't you agree that seeing the microcode revision in /proc/cpuinfo would be nice?

Well, you must be using an old-ish kernel because the microcode revision
infact *is* in /proc/cpuinfo:

processor       : 1
...
stepping        : 0
microcode       : 0x5000028

This is on 3.6-rc1 and that functionality is upstream since 3.2.

HTH.

-- 
Regards/Gruss,
Boris.
