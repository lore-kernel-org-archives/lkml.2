Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2CZUoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:44:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab2CZUoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:44:09 -0400
Date: Mon, 26 Mar 2012 22:44:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: sboyd@codeaurora.org, kernel-janitors@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/api/simple_open.cocci: semantic patch
 for simple_open()
Message-ID: <20120326204407.GC10259@sepie.suse.cz>
References: <1331657917-4552-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331657917-4552-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 05:58:37PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Find instances of an open-coded simple_open() and replace them
> with calls to simple_open().
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Reported-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, applied to kbuild.git#misc now.

Michal
