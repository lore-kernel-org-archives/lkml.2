Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2BXXMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:12:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab2BXXL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:11:56 -0500
Date: Sat, 25 Feb 2012 00:11:53 +0100
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, bruce.w.allan@intel.com, joe@perches.com,
        rusty@rustcorp.com.au
Subject: Re: [PATCH v3] scripts/coccinelle/misc/boolinit.cocci: semantic
 patch for bool issues
Message-ID: <20120224231153.GE19992@sepie.suse.cz>
References: <1328907918-31335-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328907918-31335-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 10:05:18PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> ERROR's changed to WARNING, except in assignment to non-0/1 case.

Applied to kbuild.git#misc.

Michal
