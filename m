Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2ANVpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:45:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab2ANVpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:45:02 -0500
Message-ID: <4F11F761.70406@suse.cz>
Date: Sat, 14 Jan 2012 22:45:05 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scripts/coccinelle: semantic patches related to devm_
 functions
References: <1325004092-28162-1-git-send-email-julia.lawall@lip6.fr>
In-Reply-To: <1325004092-28162-1-git-send-email-julia.lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.12.2011 17:41, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm_ functions allocate memory that is to remain allocated until the
> device is detached.  This patch checks for opportunities for using the
> function devm_request_and_ioremap.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied both patches to kbuild.git#misc. BTW, Please use different
subject lines for different patches next time, so that patches can be
referred to by their subject. I changed these two to "coccinelle:
semantic patches related to devm_ functions (part 1)" and "... (part 2)"
due to lack of better ideas.

Michal
