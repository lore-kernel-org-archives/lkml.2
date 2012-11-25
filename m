Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2KYTaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 14:30:06 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46705 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753305Ab2KYTaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 14:30:05 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+FqNQnYSiFSHSMcXNX2JAlgPOUqJSQLHVQs0Q7Tg
	bCWVPlI/RmmbqK
Message-ID: <1353871800.22969.28.camel@soupermouf>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
From: Dimitrios Apostolou <jimis@gmx.net>
To: linux-kernel@vger.kernel.org
Date: Sun, 25 Nov 2012 21:30:00 +0200
In-Reply-To: <1353851735.22969.18.camel@soupermouf>
References: <1353851735.22969.18.camel@soupermouf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-25 at 15:55 +0200, Dimitrios Apostolou wrote:
> on an old PIII-500MHz laptop, 128MB RAM, kernel 3.6.6, I started a
> backup process (tar|xz -4, nice'd and ionice'd -c3) from ext4 on local
> ATA disk to ext3 on external USB disk (USB-2.0 port on PCMCIA card).
> Even though earlier system load was minimal, free memory was plenty, the
> system now is unresponsive and is thrashing the disk, but the swapfile
> is rarely touched.

I'm now having the same experience even though I replaced xz (which
needed ~50MB RAM) with gzip. Even though I feel the realtime root shell
is a bit more responsive than before, the OOM killer is out killing 
small processes like syslog-ng and systemd-logind... The
ext4_inode_cache slab is taking almost all my memory (117MB). Please
advise!


Thanks,
Dimitris



