Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2GTQIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:08:22 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:54816 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751768Ab2GTQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:08:21 -0400
Message-ID: <5009823B.2010700@xenotime.net>
Date: Fri, 20 Jul 2012 09:07:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: linux-next: Tree for July 20 (gfs2)
References: <20120720151322.d952c13390b3078b2a5505bd@canb.auug.org.au>
In-Reply-To: <20120720151322.d952c13390b3078b2a5505bd@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 10:13 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120719:
> 




on i386 (modular):

ERROR: "__divdi3" [fs/gfs2/gfs2.ko] undefined!

or builtin:

fs/built-in.o: In function `gfs2_fallocate':
file.c:(.text+0x232086): undefined reference to `__divdi3'





-- 
~Randy
