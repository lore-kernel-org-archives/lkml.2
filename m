Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab1FQUnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:43:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51009 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab1FQUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XeZvXeckcjSu1xq2hyU9o8vhG9Fv5vsTNeByhvMTow17Q8jMTEz23zT0VBBwDkjS6R
         3VotntUtBpXKp42B2hDs3VbkmE2i/sO304JWWumbw0HbeqHvq9MCdL484RMY3nZMGUrd
         hQ7Zs7Iijm8w6HAnXycXQFkTpDWfbrQ3qpsrs=
MIME-Version: 1.0
In-Reply-To: <1308340630-16008-1-git-send-email-asharma@fb.com>
References: <1308340630-16008-1-git-send-email-asharma@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 16:42:45 -0400
Message-ID: <BANLkTinNF6E+pTMxCHqYrUWNGKCdNz8yQA@mail.gmail.com>
Subject: Re: [PATCH 1/4] atomic: use <linux/atomic.h>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i'm still of the opinion that we shouldnt have both linux/atomic.h and
asm-generic/atomic.h, but i'm not going to do anything about it right
now

with all four patches in this series, Blackfin UP and SMP systems seem
to build OK.  so i guess you can add my acked-by to all 4:
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
