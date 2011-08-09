Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab1HIE2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 00:28:08 -0400
Received: from trent.utfs.org ([194.246.123.103]:33626 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1HIE2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 00:28:06 -0400
Date: Mon, 8 Aug 2011 21:28:03 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: jeremy.fitzhardinge@citrix.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: redefinition of typedef '__guest_handle_uint64_t'
In-Reply-To: <20110808143723.GB7213@dumpdata.com>
Message-ID: <alpine.DEB.2.01.1108081727070.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1108080146000.9183@trent.utfs.org> <20110808143723.GB7213@dumpdata.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011 at 10:37, Konrad Rzeszutek Wilk wrote:
> Ugh, just use the released 3.0 stock kernel.

Thanks, 3.1-rc1 builds just fine.

I haven't built a dom0 kernel for a long time and I was looking 
at the Xensource Wiki, where Jeremy's/your tree is still referenced[0].

Thanks,
Christian.

[0] http://wiki.xensource.com/xenwiki/XenParavirtOps#head-6971c8ad23c1d86d3eed7ce8cf4e0786a0b09f0d
-- 
BOFH excuse #261:

The Usenet news is out of date
