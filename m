Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2GZKKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:10:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab2GZKKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:10:48 -0400
Message-ID: <501117A4.60704@suse.cz>
Date: Thu, 26 Jul 2012 12:10:44 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Daniel Wisehart <daniel.wisehart@eladian.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/patch-kernel fix
References: <9b2de540-7ff6-4853-8331-5b9f0d28051c@mail.eladian.com>
In-Reply-To: <9b2de540-7ff6-4853-8331-5b9f0d28051c@mail.eladian.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.7.2012 23:49, Daniel Wisehart wrote:
> diff --git a/scripts/patch-kernel b/scripts/patch-kernel
> index d000ea3..a7672eb 100755
> --- a/scripts/patch-kernel
> +++ b/scripts/patch-kernel
> @@ -226,7 +226,7 @@ fi
>  
>  # This all assumes a 2.6.x[.y] kernel tree.
>  # Don't allow backwards/reverse patching.
> -if [ $STOPSUBLEVEL -lt $SUBLEVEL ]; then
> +if [ "$STOPSUBLEVEL"0 -lt "$SUBLEVEL"0 ]; then

Hi Daniel,

While this is correct, it is not obvious at first sight why you need to
multiply the numbers by 10. Or at least it was not obvious to me :).
Could you use the more common idiom 0$NUMBER? The shell interprets the
numbers as decimal, so it's works fine.

Michal
