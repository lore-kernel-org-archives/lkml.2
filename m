Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2KFLoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:44:32 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:45922 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2KFLo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:44:29 -0500
Message-ID: <5098F816.5040206@ahsoftware.de>
Date: Tue, 06 Nov 2012 12:44:22 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
References: <5093A592.9070605@ahsoftware.de> <5093D069.20901@ahsoftware.de> <20121103044929.GB21829@liondog.tnic> <5094F5C5.1000000@ahsoftware.de> <20121104152133.GA16116@x1.osrc.amd.com> <5096A3A4.8070602@ahsoftware.de> <20121106091057.GC2090@x1.osrc.amd.com> <5098F1F5.5060709@ahsoftware.de>
In-Reply-To: <5098F1F5.5060709@ahsoftware.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2012 12:18, schrieb Alexander Holler:
> I will now to tests with leaving fglrx off.

s/to/do/ ;)

That was gone fast. Disabled fglrx, started tests, full halt without any 
visible on the serial (I needed to press the reset button):

------------------------
[   77.360180] EXT4-fs (dm-0): mounted filesystem with ordered data 
mode. Opts: data=ordered,nodelalloc
[  461.503107] EXT4-fs (sdd3): mounted filesystem with ordered data 
mode. Opts: (null)
[  473.869770] EXT4-fs (dm-1): mounted filesystem with ordered data 
mode. Opts: data=ordered,nodelalloc
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.6-00008-gd13f937 
(root@krabat.ahsoftware) (gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) 
(GCC) ) #274 SMP Mon Nov 5 17:26:01 CET 2012
[    0.000000] Command line: ro root=/dev/sdb2 rootfstype=ext4 
enforcing=0 cgroup_disable=memory vga=0x346 video=vesafb:mtrr:3,ywrap 
radeon.modeset=0 earlycon=uart8250,io,0x3f8,115200n8 
console=ttyS0,115200n8 console=tty0
------------------------

Regards,

Alexander

