Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2KYXT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:19:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50521 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753564Ab2KYXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:19:57 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18ZM0AAdnwZP6wBKqKXkDHqvZ7uzHRcQ2vv1oZYJC
	rT8W1tG1wrdh+w
Message-ID: <1353885594.22969.34.camel@soupermouf>
Subject: Re: kmemleak failure (was Re: backing up ext4 fs, system
 unresponsive, thrashing like crazy even though swap is unused)
From: Dimitrios Apostolou <jimis@gmx.net>
To: linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 01:19:54 +0200
In-Reply-To: <1353883315.22969.31.camel@soupermouf>
References: <1353851735.22969.18.camel@soupermouf>
	 <1353871800.22969.28.camel@soupermouf>
	 <1353883315.22969.31.camel@soupermouf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 00:41 +0200, Dimitrios Apostolou wrote:
> Hello,
> 
> I tried running a kmemleak and DEBUG_SLUB enabled kernel, but almost
> within 5 minutes of starting the backup process, I got:
> 
> [  486.863124] kmemleak: Cannot allocate a kmemleak_object structure
> [  486.887195] kmemleak: Automatic memory scanning thread ended
> [  486.906604] kmemleak: Kernel memory leak detector disabled

Important detail: I decided to try kmemleak after suspecting a leak
because 'echo 3>/proc/sys/vm/drop_caches' left about 90MB out of 118MB
of ext4_inode_cache, and I found no way to get rid of that (via
remounting filesystems for example).


