Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1CESvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 13:51:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64333 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1CESvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 13:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UIwixQJZTVOD1PbQLdUIffInLJzTZOVY7f01JobL5ERHyZsONR3Fzie3OlldCWEiN+
         4+p4wUCnYEn8/iS752xse6B3DAtq1ZRAkbYP0VKLqY8yA1MVNVlllB8413wEQIRzYrf0
         MRcOEHDadPc7WSZa7BWJ1dXM1tDhh30WsYMLY=
MIME-Version: 1.0
In-Reply-To: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
References: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 20:51:04 +0200
X-Google-Sender-Auth: uRljIPJCo9CBFp_mjaiYr15G134
Message-ID: <AANLkTin=gQCAf9PNjsxwJg=jF2mB-0dyuzfmYN42UQ9S@mail.gmail.com>
Subject: Re: [PATCH] mm: remove inline from scan_swap_map
From: Pekka Enberg <penberg@kernel.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 8:49 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> scan_swap_map is a large function (224 lines), with several loops and a
> complex control flow involving several gotos.
>
> Given all that, it is a bit silly that is is marked as inline. The
> compiler agrees with me: on a x86-64 compile, it did not inline the
> function.
>
> Remove the "inline" and let the compiler decide instead.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
