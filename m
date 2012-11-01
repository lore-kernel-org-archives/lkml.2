Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780Ab2KAU3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:29:08 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:37339 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab2KAU3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:29:05 -0400
Date: Thu, 1 Nov 2012 21:29:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Hogan <james@albanarts.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Michal Marek <mmarek@suse.cz>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: add symbol prefix arg to kallsyms
Message-ID: <20121101202902.GA6439@merkur.ravnborg.org>
References: <20120906211125.GB4785@balrog.le.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906211125.GB4785@balrog.le.imgtec.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:11:25PM +0100, James Hogan wrote:
> Commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 ("kbuild: link of
> vmlinux moved to a script") introduced in v3.5-rc1 broke kallsyms on
> architectures which have symbol prefixes.
> 
> The --symbol-prefix argument used to be added to the KALLSYMS command
> line from the architecture Makefile, however this isn't picked up by the
> new scripts/link-vmlinux.sh. This resulted in symbols like
> kallsyms_addresses being added which weren't correctly overriding the
> weak symbols such as _kallsyms_addresses. These could then trigger
> BUG_ONs in kallsyms code.
> 
> This is fixed by removing the KALLSYMS addition from the architecture
> Makefile, and using CONFIG_SYMBOL_PREFIX in the link-vmlinux.sh script
> to determine whether to add the --symbol-prefix argument.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
