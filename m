Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab1FABIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:08:54 -0400
Received: from trent.utfs.org ([194.246.123.103]:59648 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004Ab1FABIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:08:53 -0400
Date: Tue, 31 May 2011 18:08:51 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
In-Reply-To: <alpine.DEB.2.01.1105311744000.21697@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1105311806220.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org> <1306887942.29297.10.camel@pasglop> <alpine.DEB.2.01.1105311744000.21697@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 at 17:48, Christian Kujau wrote:
> On Wed, 1 Jun 2011 at 10:25, Benjamin Herrenschmidt wrote:
> > Hrm, I had it working on a pair of powerbooks yesterday. Can you try
> > something like "udbg-immortal" on your kernel command line to see if
> > that makes a difference in the output ?
> 
> I'll try in a minute.

Wow, it really did make a difference:

  http://nerdbynature.de/bits/3.0-rc1/
  * linux-3.0_powerpc_2.jpg
  * linux-3.0_powerpc_2.mp4 (only a few(!) seconds long,
    best to view with the slider in VLC oder Quicktime, to
    get at least a grasp what lead to linux-3.0_powerpc_2.jpg)

Thanks,
Christian.
-- 
BOFH excuse #45:

virus attack, luser responsible
