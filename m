Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2DBVYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:24:13 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44932 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2DBVYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:24:11 -0400
MIME-Version: 1.0
In-Reply-To: <1333401674-26007-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333401674-26007-1-git-send-email-paul.gortmaker@windriver.com>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 2 Apr 2012 17:23:50 -0400
Message-ID: <CAEdQ38G=uwPuN1fmZca1w+1q0HGiLzLYP8DkZ-AFiRQcPJT+JA@mail.gmail.com>
Subject: Re: [PATCH] alpha: fix build failures from system.h dismemberment
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 5:21 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> commit ec2212088c42ff7d1362629ec26dda4f3e8bdad3
>
>    "Disintegrate asm/system.h for Alpha"
>
> combined with commit b4816afa3986704d1404fc48e931da5135820472
>
>    "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"
>
> introduced the concept of asm/cmpxchg.h but the alpha arch
> never got one.  Fork the cmpxchg content out of the asm/atomic.h
> file to create one.
>
> Some minor whitespace fixups were done on the block of code that
> created the new file.
>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Matt Turner <mattst88@gmail.com>
