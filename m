Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2EVJBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab2EVJB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:01:26 -0400
Date: Tue, 22 May 2012 11:01:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the mips
 tree
In-Reply-To: <20120522145041.67536df96e34135fd802fd2b@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1205221101020.16396@pobox.suse.cz>
References: <20120522145041.67536df96e34135fd802fd2b@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/mips/pci/pci-lantiq.c between commit 57c8cb8f2429 ("MIPS: pci:
> convert lantiq driver to OF") from the mips tree and commit 6997991ab0db
> ("mips: Fix printk typos in arc/mips") from the trivial tree.
> 
> The former did the fix from the latter as a side effect so I used that.

I have dropped the hunk from trivial.git to avoid the unnecessary 
conflict, thanks.

-- 
Jiri Kosina
SUSE Labs
