Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1GHU0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:26:50 -0400
Received: from trent.utfs.org ([194.246.123.103]:42374 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1GHU0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:26:49 -0400
Date: Fri, 8 Jul 2011 13:26:41 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: mmarek@suse.cz
Subject: Re: .tmp_depmod owned by root after modules_install
In-Reply-To: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1107081326190.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ping?

On Mon, 4 Jul 2011 at 02:49, Christian Kujau wrote:
> Hi,
> 
> when building a kernel with O=$DIR, I noticed that "modules_install" now 
> creates files under $DIR as root:
> 
> $ sudo make -C /usr/local/src/linux-2.6-git O=$HOME/trash/tmp/. modules_install
> [...]
> 
> When trying to build a new kernel, removing $DIR as a normal user does no 
> longer work as everything under $HOME/trash/tmp/.tmp_depmod/ is now owned 
> by root (because of the "sudo"). This did not occur before and may be a 
> consequence of:
> 
>   commit bfe5424a8b31624e7a476f959d552999f931e7c7
>   Author: Michal Marek <mmarek@suse.cz>
>   Date:   Thu Jun 9 16:35:41 2011 +0200
> 
>     kbuild: Hack for depmod not handling X.Y versions
> 
> Can this be changed somehow so that "make modules_install" does not write 
> anything under $DIR, as before?
> 
> Thanks,
> Christian.
> -- 
> BOFH excuse #274:
> 
> It was OK before you touched it.
> 

-- 
BOFH excuse #188:

..disk or the processor is on fire.
