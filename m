Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0ENPQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:16:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57791 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0ENPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:16:09 -0400
To: Julia Lawall <julia@diku.dk>
Cc: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/20] arch/arm/mach-davinci: Use kzalloc
References: <Pine.LNX.4.64.1005132159170.6282@ask.diku.dk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 08:16:04 -0700
In-Reply-To: <Pine.LNX.4.64.1005132159170.6282@ask.diku.dk> (Julia Lawall's message of "Thu\, 13 May 2010 21\:59\:32 +0200 \(CEST\)")
Message-ID: <87d3wyqzt7.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> From: Julia Lawall <julia@diku.dk>
>
> Use kzalloc rather than the combination of kmalloc and memset.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression x,size,flags;
> statement S;
> @@
>
> -x = kmalloc(size,flags);
> +x = kzalloc(size,flags);
>  if (x == NULL) S
> -memset(x, 0, size);
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
