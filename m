Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab0LVLAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:00:31 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:56465 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0LVLAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:00:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=YEHAA8WNdBD6VnEb7T/URTsMzWfLkl6Vwd7rq1MAIVjEBEZP2yjQL/gIdbu4M6ZUCG
         mse6Q++Q1BEPvI7jRhrFW8bD/nHn2FfFx1Tatw4Y7lQLA9F8LrZRXebljbt4q/lCCx90
         6BVZFGrSXjvsOcut+G3Orzcs9chMe2rR7Jjmo=
Date: Wed, 22 Dec 2010 11:00:21 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joel Soete <soete.joel@scarlet.be>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Help: major pppoe regression since 2.6.35 (panic on first ppp
	conection)?
Message-ID: <20101222110021.GA8985@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222002215.fb0bfe95.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-22 09:22, Andrew Morton wrote:
> (cc netdev)
> 
> The bug is still present in 2.6.37-rc6.
> 
> On Sat, 18 Dec 2010 11:33:14 +0000 Joel Soete <soete.joel@scarlet.be> wrote:
> 
>> Hello all,

Hi,
Could you reproduce this bug with a vanilla kernel (without nvidia
patch)? If so, please include dmesg and .config to the next report.

Cheers,
Jarek P.

...
>> Dec 17 17:28:12 sidh2 kernel: [  106.511762] BUG: unable to handle kernel NULL pointer dereference at (null)
>> Dec 17 17:28:12 sidh2 kernel: [  106.511952] IP: [<ffffffff810e405b>] put_page+0x1b/0x180
>> Dec 17 17:28:12 sidh2 kernel: [  106.512078] PGD 13c6f0067 PUD 134283067 PMD 0
>> Dec 17 17:28:12 sidh2 kernel: [  106.512293] Oops: 0000 [#1] SMP
>> Dec 17 17:28:12 sidh2 kernel: [  106.512456] last sysfs file: /sys/devices/virtual/sound/timer/uevent
>> Dec 17 17:28:12 sidh2 kernel: [  106.512533] CPU 4
>> Dec 17 17:28:12 sidh2 kernel: [  106.512584] Modules linked in: ppdev xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables 
>> x_tables lp nvidia(P) parport_pc parport agpgart i7core_edac edac_core tpm_tis tpm tpm_bios [last unloaded: scsi_wait_scan]
>> Dec 17 17:28:12 sidh2 kernel: [  106.513674]
>> Dec 17 17:28:12 sidh2 kernel: [  106.513742] Pid: 1821, comm: pppd Tainted: P            2.6.35-amd64-t3 #5 EX58-UD3R/EX58-UD3R
...
