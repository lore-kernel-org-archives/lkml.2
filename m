Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1CBRKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:10:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1CBRKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:10:17 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=owA0imprsKQA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zqI2FTgMvshtYQsv4DYA:9 a=v5IhPhKkLlbm2_PKrALWfyaEGsUA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 2 Mar 2011 12:10:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alvaro Aguilera <alvaro.aguilera@mailbox.tu-dresden.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about the vmlinuz file
Message-ID: <20110302171015.GA8960@home.goodmis.org>
References: <AANLkTimtj=8ikdzgUiaT+y1MsjfGNU3LcyaUMPU0wMEh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimtj=8ikdzgUiaT+y1MsjfGNU3LcyaUMPU0wMEh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 01:25:24PM +0100, Alvaro Aguilera wrote:
> Hello,
> 
> perhaps someone here has a couple of minutes to explain me the
> difference between these two vmlinuz files from different
> distributions:

What distributions?

On my Fedora 12 laptop:

$ file /boot/vmlinuz-2.6.32.23-170.fc12.x86_64 
/boot/vmlinuz-2.6.32.23-170.fc12.x86_64: Linux kernel x86 boot executable bzImage, version 2.6.32.23-170.fc12.x86_64 (mock, RO-rootFS, root_dev 0x902, swap_dev 0x3, Normal VGA

On my debian box:

$ file /boot/vmlinuz-2.6.32-trunk-amd64 
/boot/vmlinuz-2.6.32-trunk-amd64: Linux kernel x86 boot executable bzImage, version 2.6.32-trunk-amd64 (unknown@Deb, RO-rootFS, swap_dev 0x2, Normal VGA

> 
> $file /boot/vmlinuz
> /boot/vmlinuz-2.6.37-40-desktop: Linux/x86 Kernel, Setup Version
> 0x20a, bzImage, Version 2.6.37, Version 2.6.37-40, RO-rootFS, root_dev
> 0x301, swap_dev 0x4, Normal VGA

This seems to match my two boxes.

> 
> $file /boot/vmlinuz
> vmlinuz: ELF 64-bit LSB shared object, AMD x86-64, version 1, stripped
> 
> the second file seems to be in ELF format and I cannot use it with my
> cluster management software.

What distro is it?

> 
> Is there a parameter I can use to compile the kernel image in one
> format or the other? or a tool to convert them?

When I build my own kernel on Debian I have:

$ file /boot/vmlinuz-2.6.37.1+ 
/boot/vmlinuz-2.6.37.1+: Linux kernel x86 boot executable bzImage, version 2.6.37.1+ (rostedt@gandalf) #23, RO-rootFS, root_dev 0x900, swap_dev 0x2, Normal VGA

Your second file looks more like a vmlinux than a vmlinuz file.

$ file vmlinux
vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped

-- Steve
