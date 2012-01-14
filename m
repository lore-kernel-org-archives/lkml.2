Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2ANWQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 17:16:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab2ANWQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 17:16:00 -0500
Message-ID: <4F11FEA4.3050502@suse.cz>
Date: Sat, 14 Jan 2012 23:16:04 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Artem@mgw2.diku.dk, Bityutskiy@suse.de
Subject: Re: [PATCH] scripts/coccinelle: improve the coverage of some semantic
 patches
References: <1326562543-8448-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1326562543-8448-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.1.2012 18:35, Julia Lawall wrote:
> diff --git a/var/linuxes/linux-next/scripts/coccinelle/locks/call_kern.cocci b/var/julia/linuxcopy/scripts/coccinelle/locks/call_kern.cocci
> index 00af534..8f10b49 100644
> --- a/var/linuxes/linux-next/scripts/coccinelle/locks/call_kern.cocci
> +++ b/var/julia/linuxcopy/scripts/coccinelle/locks/call_kern.cocci

Please submit a patch that applies to the kernel git, thanks.

Michal
