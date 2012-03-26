Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2CZUox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:44:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab2CZUov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:44:51 -0400
Date: Mon, 26 Mar 2012 22:44:50 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, imirkin@alum.mit.edu,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] scripts/coccinelle/api/ptr_ret.cocci: semantic patch
 for ptr_err
Message-ID: <20120326204450.GD10259@sepie.suse.cz>
References: <1332699179-18934-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332699179-18934-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 08:12:59PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Fixed warning messages to refer to the right function.
> 
>  scripts/coccinelle/api/ptr_ret.cocci |   70 +++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)

Applied to kbuild.git#misc, thanks.

Michal
