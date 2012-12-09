Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2LIPEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:04:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab2LIPEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:04:31 -0500
Date: Sun, 9 Dec 2012 16:04:30 +0100
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/misc/warn.cocci: use WARN
Message-ID: <20121209150429.GA29236@pobox.suse.cz>
References: <1351972929-7448-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351972929-7448-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 09:02:09PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use WARN(1,...) rather than printk followed by WARN(1).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  scripts/coccinelle/misc/warn.cocci |  109 +++++++++++++++++++++++++++++++++++++

Applied to kbuild.git#misc, thanks.

Michal
