Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1FMAwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:52:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44319 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab1FMAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to;
        b=ZJyM++xOklJvzQlJEHsCSAPTS7rE3rbQfqTrUHjdBYRh8YwJcL4arHwr0Q1wOloegS
         9lvXdeug43QxDA0zXhOyeNtHzRXJwrmfvLuhd7mC50QzZjBGLAS5/tC+vVtuqgfnLHcx
         EqpoCj3uSwIn2k2nBa8sTcoysrSIYdozWTtN4=
Date: Sun, 12 Jun 2011 18:51:22 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/sched.c: Fix array initialization typo
Message-ID: <20110613005122.GC12311@mail.gmail.com>
References: <20110612213107.GA12816@mail.gmail.com>
 <20110612213549.GA21620@p183.telecom.by>
 <20110612220116.GB12311@mail.gmail.com>
 <20110612230901.GB11580@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612230901.GB11580@hexapodia.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Isaacson <adi@hexapodia.org>
Date: Sun, 12 Jun 2011 16:09:01 -0700
>
> It is a standard C idiom for defining array contents.  If you write
> int x[] = {
>     1,
>     2,
>     3
> };
> 
> then when I add a fourth element to your array, I have to modify two
> lines, and the diff will say
> -    3
> +    3,
> +    4
>  };
> 
> whereas if you wrote "3," as the last line of the initializer, the diff
> would be one line long.

I don't know how to thank you for this. Apparently the patch is bogus.
> 
> Furthermore, spot the error in this diff:
> 
> @@ -3,4 +3,5 @@ char *x[] = {
>      "quick",
>      "brown",
>      "fox"
> +    "jumped"
>  };
> 
> HTH, HAND,
> -andy

-- 
Jean Sacren
