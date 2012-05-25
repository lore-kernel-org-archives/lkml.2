Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2EYMxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:53:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab2EYMxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:53:15 -0400
Date: Fri, 25 May 2012 14:53:14 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] scripts/coccinelle: sizeof of pointer
Message-ID: <20120525125314.GB24532@sepie.suse.cz>
References: <1335032628-5152-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335032628-5152-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 08:23:48PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> v2, with a better subject
> 
>  scripts/coccinelle/misc/noderef.cocci |   65 ++++++++++++++++++++++++++++++++++

Applied to kbuild.git#misc, thanks.

Michal
