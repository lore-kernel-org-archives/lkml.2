Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab0DBFNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:13:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40627 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab0DBFNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CjIM/poju0JFcQh2iRD7FbEnpDro5/DEH0LTx1mUKqRAICpNKsRXRENp8wAjnSErd/
         6s7FCEFCvJzoOeRv/l0DuoYZxuREBhQcKGShq5S8f/MIQcGxMFd8JfpmoCKKbNL5NDG5
         cyhTEvH1TxCeCEbq3v9M6sEyRi9ZvkBgn8Fs0=
MIME-Version: 1.0
In-Reply-To: <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
References: <i2i5f4a33681003312105m4cd42e9ayfe35cc0988c401b6@mail.gmail.com>
	 <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
Date: Fri, 2 Apr 2010 14:13:09 +0900
Message-ID: <o2j28c262361004012213tc9fdebc7yc535f4130a86e644@mail.gmail.com>
Subject: Re: [Question] race condition in mm/page_alloc.c regarding page->lru?
From: Minchan Kim <minchan.kim@gmail.com>
To: TAO HU <tghk48@motorola.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chang Qing-A21550 <Qing.Chang@motorola.com>,
       linux-arm-kernel@lists.infradead.org, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 12:51 PM, TAO HU <tghk48@motorola.com> wrote:
> 2 patches related to page_alloc.c were applied.
> Does anyone see a connection between the 2 patches and the panic?

Seem to not related to the problem.
I don't have seen the problem before.

Could you git-bisect to make sure which patch makes bug?
Is it reproducible?
Can I reproduce it in QEMU-goldfish?

-- 
Kind regards,
Minchan Kim
