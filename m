Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2JKMvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:51:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab2JKMvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:51:42 -0400
Date: Thu, 11 Oct 2012 14:51:40 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/tests/odd_ptr_err.cocci: semantic
 patch for IS_ERR/PTR_ERR inconsistency
Message-ID: <20121011125140.GA16465@sepie.suse.cz>
References: <1345927365-26814-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345927365-26814-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 10:42:45PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  scripts/coccinelle/tests/odd_ptr_err.cocci |   65 +++++++++++++++++++++++++++++

Looks like I missed this one. I applied it to kbuild.git#misc now.

thanks,
Michal
