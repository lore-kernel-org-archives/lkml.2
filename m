Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1EJHry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:47:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49833 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1EJHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OuzXwL8zS3NdmIyH90waxubtIo7YP4HebCxE9asgN49XGnzX8p2na9NPh2hiH1jly4
         t6YbgCJMx/onQ6AaHJ6gjDq0BIp5b6883pLT7tKcoHAzC4aUer+gt+rQSgO0aeJ3RvqY
         r+AgpS09IkjpkrbgktS2QE+wbNN7Z0ByEnbFg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105091811320.15483@pc-004.diku.dk>
References: <4DC7F4AB.90607@gmail.com>
	<Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk>
	<4DC802C0.9040302@gmail.com>
	<Pine.LNX.4.64.1105091713080.15483@pc-004.diku.dk>
	<4DC8117C.7060200@gmail.com>
	<Pine.LNX.4.64.1105091811320.15483@pc-004.diku.dk>
Date: Tue, 10 May 2011 10:47:52 +0300
Message-ID: <BANLkTinhy7QwE0a40efJhHazmGSgitKVdw@mail.gmail.com>
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference 'idata'
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Vladimir Motyka <vladimir.motyka@gmail.com>, cjb@laptop.org,
        kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 7:12 PM, Julia Lawall <julia@diku.dk> wrote:
> I guess there is also a point at which idata has been successfully
> allocated but idata->buf has not.
And? kfree() simple ignores NULL pointers.
I would prefer to see previous version of patch, but let maintainer to choose.

-- 
With Best Regards,
Andy Shevchenko
