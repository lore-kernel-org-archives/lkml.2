Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1CERFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:05:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41278 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1CERFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:05:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=R76xOQmrVdqvK3gGD8TcCHajA92NLeoy1kXtcEVgyq0OCHQDDMH8WIDqHFLtnk/toU
         Tg2xmNrYtQuQQfZ498/4m7nL5McbtPsnomAGSoyGrZmX1Id4g14+wZWpMAVf84Zgzaek
         9AoNVOmZyaPkeW6nPYMpCXnpiGmHmcEDqEvjw=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-3-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-3-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:05:01 +0200
X-Google-Sender-Auth: ub4nyL8H1Dj3dDIC--ZrX3suing
Message-ID: <AANLkTik-75TNoUZ-XLm4nmbq7zJSbUn+gECHYhQiN43C@mail.gmail.com>
Subject: Re: [PATCHv2 02/24] sys_swapon: remove changelog from function comment
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
> Changelogs belong in the git history instead of in the source code.
>
> Also, "The swapon system call" is redundant with
> "SYSCALL_DEFINE2(swapon, ...)".
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
