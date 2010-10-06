Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab0JFJgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:36:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:50251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab0JFJgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:36:20 -0400
Date: Wed, 6 Oct 2010 11:36:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
In-Reply-To: <20101006141414.abf7431f.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1010061135370.29535@pobox.suse.cz>
References: <20101006141414.abf7431f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Stephen Rothwell wrote:

> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/musb/musb_gadget.c between commit
> 7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> unnecessary return's from void functions") from the trivial tree and
> commit 82cccbf2458e50dabf8b9946b3f0ef0e8d31711f ("usb: musb: gadget: kill
> unreachable code in musb_g_rx()") from the usb tree.
> 
> The latter also fixes the problem fixed in the former, so I just used the
> latter.

I have reverted the hunk in question in my tree, so the conflict should be 
gone now.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
