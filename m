Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423824Ab2LFPQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:16:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37793 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423776Ab2LFPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:16:04 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+L450lK9SLb1I3+NOWLrld5VJwrj52wdPSlEZ+pS
	zEI6mOMEbALeAS
Date: Thu, 6 Dec 2012 17:15:37 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@soupermouf
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
In-Reply-To: <20121206142044.GB18547@quack.suse.cz>
Message-ID: <alpine.LFD.2.02.1212061711170.1646@soupermouf>
References: <1353851735.22969.18.camel@soupermouf> <1353871800.22969.28.camel@soupermouf> <20121206142044.GB18547@quack.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012, Jan Kara wrote:
> On Sun 25-11-12 21:30:00, Dimitrios Apostolou wrote:
>> On Sun, 2012-11-25 at 15:55 +0200, Dimitrios Apostolou wrote:
>>> on an old PIII-500MHz laptop, 128MB RAM, kernel 3.6.6, I started a
>>> backup process (tar|xz -4, nice'd and ionice'd -c3) from ext4 on local
>>> ATA disk to ext3 on external USB disk (USB-2.0 port on PCMCIA card).
>>> Even though earlier system load was minimal, free memory was plenty, the
>>> system now is unresponsive and is thrashing the disk, but the swapfile
>>> is rarely touched.
>>
>> I'm now having the same experience even though I replaced xz (which
>> needed ~50MB RAM) with gzip. Even though I feel the realtime root shell
>> is a bit more responsive than before, the OOM killer is out killing
>> small processes like syslog-ng and systemd-logind... The
>> ext4_inode_cache slab is taking almost all my memory (117MB). Please
>> advise!
>  Hmm, it seems commit 4eff96dd5283a102e0c1cac95247090be74a38ed might be
> interesting for you. It landed in -stable kernels recently as well if I
> remember right...

Thanks, I appreciate your help as I'm stuck in a dead end now, and I've 
been trying to write some debug hook that prints all ext4_inodes and the 
reason they are pinned (is there an easy way to find this out?).

So maybe there is a typo in the SHA1 sum you provided? Gitweb can't find 
it in Linus' tree.


Thanks,
Dimitris

