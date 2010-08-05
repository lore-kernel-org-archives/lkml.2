Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab0HEKRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:17:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:33351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0HEKRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:17:09 -0400
Date: Thu, 5 Aug 2010 12:17:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P.Mattock" <justinmattock@gmail.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
In-Reply-To: <20100805132208.74bf6ab9.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1008051216260.29919@pobox.suse.cz>
References: <20100805132208.74bf6ab9.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Stephen Rothwell wrote:

> Today's linux-next merge of the usb tree got a conflict in
> Documentation/usb/linux.inf between commit
> 0ea6e61122196509af82cc4f36cbdaacbefb8227 ("Documentation: update broken
> web addresses") from Linus' tree and commit
> 2e73ce9389be011587a0ca581b6798b135e64807 ("USB: gadget: g_ether: updated
> INF file") from the usb tree.
> 
> The URL that was fixed by the former was removed by the latter, so I just
> used the latter version.

I see. Greg, will you just rebase the patch in USB tree on top of current 
Linus' tree please?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
