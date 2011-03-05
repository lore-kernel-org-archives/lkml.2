Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1CEREh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:04:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51932 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1CEREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Sx40Ub4halNnIzAQqPhZB1ZkaF1HQyKJwDIiNwQkJDz86r2arFjLL68MERLx7/JaTL
         8K+bL/65q90OyRSG769Ktn646FctzZJ59drU0lOjETD0w+cDVgfNzoIj6pwwSwcQIX1t
         HwhlzI0qH8rICMQFFn661Rg3dDVed3iHJreEk=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-2-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-2-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:04:35 +0200
X-Google-Sender-Auth: N6X1sPUmlngKeH2G208pM2SKg3s
Message-ID: <AANLkTikxOWZ5+KEe0x-AOhSQNQhLkYNVhE9qoKvk5Y_1@mail.gmail.com>
Subject: Re: [PATCHv2 01/24] sys_swapon: use vzalloc instead of vmalloc/memset
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
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
