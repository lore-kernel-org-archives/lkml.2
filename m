Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1HEIqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:46:18 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48237 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1HEIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:46:16 -0400
Date: Fri, 5 Aug 2011 10:46:14 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
Message-ID: <20110805084614.GA1588@x4.trippels.de>
References: <20110805010038.GA18148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805010038.GA18148@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.08.04 at 21:00 -0400, Dave Jones wrote:
> Sometime in the last week, something was merged which causes my laptop
> to lock up occasionally.  I can trigger it most of the time just by
> doing a kernel build. When it gets to the final linking stage, it locks up hard.
> 
> I finally managed to coax something out of usb console to get the traces below,
> which seem to implicate something in the block layer ?
> 
> my root device is an lvm volume on an dmcrypt'd block dev, which might be relevant,
> as I don't see this happening on other machines with simpler setups.
> 
> I'm going to try bisecting, but it might take me a few days, because it's
> such a pain in the ass to reproduce this reliably.
> 
> 	Dave
> 
> 
> [ 5913.233035] ------------[ cut here ]------------
> [ 5913.233097] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [ 5913.233101] Hardware name: Adamo 13   
> [ 5913.233105] list_del corruption. prev->next should be ffffea000434fd20, but was ffffea0004199520

See also: http://lkml.org/lkml/2011/8/3/37

-- 
Markus
