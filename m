Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0DDX4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:56:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43168 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0DDX4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UFCN9UNrbT7vRF649B1wMbdAJhfymeVgNfBzWWA8qKltvRsobudP4S8N0eqRXolzw6
         4qqxQiUre9DasQmbp9rAp5gbof3EUkwDLuZuDkcCBskAMCSFtU9gGN541e6Z+Zt8GuGU
         qhkxGAQdPZ+s2+uMtA5zAyFEkeRo8WsdISI38=
MIME-Version: 1.0
In-Reply-To: <20100404190925.5daac2f3@annuminas.surriel.com>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100402112428.f46ddc44.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
	 <4BB66941.1060809@redhat.com>
	 <1270397575.1814.106.camel@barrios-desktop>
	 <20100404190925.5daac2f3@annuminas.surriel.com>
Date: Mon, 5 Apr 2010 08:56:33 +0900
Message-ID: <l2u28c262361004041656ne3276035j6fb0cf6f0a42d278@mail.gmail.com>
Subject: Re: [PATCH] rmap: fix anon_vma_fork() memory leak
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 5, 2010 at 8:09 AM, Rik van Riel <riel@redhat.com> wrote:
> Fix a memory leak in anon_vma_fork(), where we fail to tear down the
> anon_vmas attached to the new VMA in case setting up the new anon_vma
> fails.
>
> Reported-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
