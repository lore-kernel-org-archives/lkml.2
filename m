Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab2BJU6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:58:12 -0500
Received: from ozlabs.org ([203.10.76.45]:57581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab2BJU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:58:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        bruce.w.allan@intel.com, joe@perches.com
Subject: Re: [PATCH v2] scripts/coccinelle/misc/boolinit.cocci: semantic patch for bool issues
In-Reply-To: <1328905355-30874-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328905355-30874-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 11 Feb 2012 07:27:01 +1030
Message-ID: <874nuye7aa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 21:22:35 +0100, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

FWIW: 
Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>

> +coccilib.report.print_report(p2[0],"WARNING: Assignment of bool to non-0/1 constant")

IMHO, this one should be an error!

Thanks,
Rusty.
