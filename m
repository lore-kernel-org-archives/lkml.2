Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1KUCDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 21:03:37 -0500
Received: from trent.utfs.org ([194.246.123.103]:42789 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1KUCDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 21:03:35 -0500
Date: Sun, 20 Nov 2011 18:03:32 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: 3.2.0-rc1 panic on PowerPC
In-Reply-To: <1321840301.13860.9.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1111201759500.8000@trent.utfs.org>
References: <alpine.DEB.2.01.1111150035560.8000@trent.utfs.org>  <alpine.DEB.2.01.1111201529070.8000@trent.utfs.org>  <1321837101.13860.6.camel@pasglop>  <alpine.DEB.2.01.1111201701000.8000@trent.utfs.org>  <1321838742.13860.8.camel@pasglop>
 <1321840301.13860.9.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 at 12:51, Benjamin Herrenschmidt wrote:
> BTW. SLUB or SLAB ? Mine was SLUB with SLUB_DEBUG enabled (tho the debug
> didn't seem to catch anything).

SLUB, and SLUB_DEBUG=y (but w/o SLUB_DEBUG_ON and SLUB_STATS). Full config 
here: http://nerdbynature.de/bits/3.2.0-rc1/oops/config.txt

I'm compiling today's git checkout (mainline) with more debug settings 
enabled[0], let's see if this helps anything.

Christian.

[0] diff to old config
+CONFIG_RT_MUTEX_TESTER=y
+CONFIG_DEBUG_LOCKDEP=y
+CONFIG_DEBUG_HIGHMEM=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_WRITECOUNT=y
+CONFIG_DEBUG_LIST=y
+CONFIG_ATOMIC64_SELFTEST=y
+CONFIG_XMON=y
+CONFIG_XMON_DEFAULT=y
+CONFIG_XMON_DISASSEMBLY=y
+CONFIG_DEBUGGER=y

-- 
BOFH excuse #242:

Software uses US measurements, but the OS is in metric...
