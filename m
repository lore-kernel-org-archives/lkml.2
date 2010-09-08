Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab0IHHmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:42:52 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37629 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab0IHHmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:42:51 -0400
Date: Wed, 8 Sep 2010 09:42:48 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Chris Dearman <chris@mips.com>
Subject: Re: commit f6be75d03c88 broke qemu-system-mips64.
Message-ID: <20100908074248.GB9501@linux-mips.org>
References: <201009041754.28716.rob@landley.net>
 <4C866868.6060606@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C866868.6060606@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 09:29:28AM -0700, David Daney wrote:

> >You'll need QEMU installed.  Note that Ubuntu's qemu package is actually
> >kqemu, and doesn't support any non-x86 targets.  You need to install
> >"qemu-kvm-extras" to get _actual_ qemu.  I don't know why they broke this.
> >
> >Once you've confirmed it used to work, replace the zImage-mips64 file with a
> >vmlinux built using the attached .config and ./run-emulator.sh again.  If you
> >build f6be75d03c88 it fails, but f6be75d03c88^1 works.  If you build 2.6.35
> >but revert the f6be75d03c88 patch (all one line of it), it works.  If you don't
> >revert it, v2.6.35 is still broken.
> >
> >Rob
> 
> Has anybody tried it on a real 64-bit Malta?  Perhaps the emulator
> is broken.

There is no MIPS64 R2 core for the Malta.  I think the best evidence pointing
to an emulator issue is that the current code is working on Cavium.

  Ralf
