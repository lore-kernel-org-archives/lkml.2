Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1CERWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:22:16 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41353 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1CERWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:22:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fVbNyN4+ogSlIyRJtGfdTYrUc75DDvWEPtR/SFI7IA/EZnf7k/OE2+v4N7LLq78NUY
         1vojbuTEZjEOCovKdoqeYUOibZle1iVKjxufqPEusuQdsRXZLiXpiMLWeeLVzZMYrc0J
         r7AB/pFRjmfnGW1rVNP6lKtr38k1/WVRfpTSI=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-21-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-21-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:22:15 +0200
X-Google-Sender-Auth: VJ8WbPTE3K-qQ9zlp9Rnb2uAjms
Message-ID: <AANLkTi=uVpRUC3BC_AFcR7hLaxz4hqR6dz2YBzjUvCGW@mail.gmail.com>
Subject: Re: [PATCHv2 20/24] sys_swapon: simplify error flow in setup_swap_map_and_extents
From: Pekka Enberg <penberg@kernel.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 6:42 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Since there is no cleanup to do, there is no reason to jump to a label.
> Return directly instead.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
