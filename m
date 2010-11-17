Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab0KQLA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:00:27 -0500
Received: from smtp.nokia.com ([147.243.1.48]:37949 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab0KQLA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:00:26 -0500
Date: Wed, 17 Nov 2010 12:52:48 +0200
From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
To: ext Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] proc/vmcore: allow archs to override
	vmcore_elf_check_arch()
Message-ID: <20101117105248.GV17801@esdhcp04058.research.nokia.com>
References: <cover.1289292124.git.mika.westerberg@iki.fi> <df680f67f33d8b0ef815045b53f205b3ff35de63.1289292124.git.mika.westerberg@iki.fi> <20101116142850.df5e9805.akpm@linux-foundation.org> <20101116225042.GH21926@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101116225042.GH21926@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:50:42PM +0000, ext Russell King - ARM Linux wrote:
[...]
> 
> So, as far as the above patch goes, I think it's sane, as it now
> allows architectures to deal with the 64-bit/32-bit ELF issues in the
> crash dump code in a more sane manner.

Russell,

Is it ok if I submit this patch (along with patches 2 and 3) to your patch
system as Andrew suggested, or do you prefer to merge it via some other tree?

Thanks,
MW
