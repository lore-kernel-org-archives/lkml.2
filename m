Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1GFP5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:57:35 -0400
Received: from mail.southpole.se ([193.12.106.18]:60798 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1GFP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:57:32 -0400
Subject: Re: linux-next: manual merge of the rr tree with the  tree
From: Jonas Bonn <jonas@southpole.se>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <20110705135932.de7f0526.sfr@canb.auug.org.au>
References: <20110705135932.de7f0526.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 17:57:27 +0200
Message-ID: <1309967847.3393.44.camel@jerome>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-07-05 at 13:59 +1000, Stephen Rothwell wrote:
> Hi Rusty,
> 
> Today's linux-next merge of the rr tree got a conflict in
> arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c between commit
> 4528acce2607 ("m68k: merge the non-mmu and mmu versions of module.c")
> from the m68knommu tree and commit 7b935befe6bc ("modules: make arch's
> use default loader hooks") from the rr tree.
> 
> The former removes these files, so I did that.
> 
> I then added this merge fix up patch (which I can carry as necessary and
> may not be coorrect):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 5 Jul 2011 13:12:26 +1000
> Subject: [PATCH] modules/m68k: make arch's use default loader hooks
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/m68k/kernel/module.c |   27 ---------------------------
>  1 files changed, 0 insertions(+), 27 deletions(-)
> 

That patch looks good to me.

Acked-by: Jonas Bonn <jonas@southpole.se>

/Jonas

