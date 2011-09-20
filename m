Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964Ab1ITNE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:04:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab1ITNEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:04:48 -0400
Date: Tue, 20 Sep 2011 15:04:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: linux-next: manual merge of the trivial tree with the kernel-doc
 tree
In-Reply-To: <20110919163946.9165592b447bf5b578146f83@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1109201504040.13109@pobox.suse.cz>
References: <20110919163946.9165592b447bf5b578146f83@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> Documentation/PCI/pci.txt between commit b814f0357fbe
> ("Documentation/PCI/pci.txt: fix a reference doc name") from the
> kernel-doc tree and commit c460578a674f ("Documentation: fix broken
> references") from the trivial tree.
> 
> It looks like the former supercedes the latter, so I used that.

I don't know where to get either linux-next or linux-doc at the moment, so 
just correct me if I am wrong -- I will just drop the 
Documentation/PCI/pci.txt hunk from c460578a674f in my tree, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
