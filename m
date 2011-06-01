Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1FAAsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:48:20 -0400
Received: from trent.utfs.org ([194.246.123.103]:39382 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab1FAAsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:48:19 -0400
Date: Tue, 31 May 2011 17:48:17 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
In-Reply-To: <1306887942.29297.10.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1105311744000.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org> <1306887942.29297.10.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 at 10:25, Benjamin Herrenschmidt wrote:
> Hrm, I had it working on a pair of powerbooks yesterday. Can you try
> something like "udbg-immortal" on your kernel command line to see if
> that makes a difference in the output ?

I'll try in a minute.

In the meantime, "git bisect" behaves kinda weird, I don't know what went 
wrong here:

 $ git bisect start
 $ git bisect good         # Linux 2.6.39
 $ git bisect bad v3.0-rc1 # Linux 3.0-rc1
 $ git bisect bad          # c44dead70a...
 $ git bisect bad          # d93515611b..

...yet the ./Makefile shows[0] that I'm already way behind: 2.6.39-rc2. 
Maybe "git bisect" got confused with that whole 2.6.x -> 3.0 renaming?

Christian.

[0] http://nerdbynature.de/bits/3.0-rc1/
-- 
BOFH excuse #383:

Your processor has taken a ride to Heaven's Gate on the UFO behind Hale-Bopp's comet.
