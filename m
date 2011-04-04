Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1DDK3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:29:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38244 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab1DDK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=Hc4MUuqPX18xIj0vIkIHGmcXaHSPuHNZzBZZqXGpz62AIJWKCuK8a3kOB0c5k9vqMu
         lk44JlYMoHp7OetdDqmnPB4OKpd1G1MbHdF4fbkLJJ7F3g1h53kvK39YMryLlNmwlT5S
         lixUMj1Llrw4xGqZ6ezQ+u6pIIT7FU7mdGeaI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1301911604.2760.52.camel@localhost>
References: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
	<1301900656.2760.6.camel@localhost>
	<BANLkTi=WTWa4yj+ysta8jiHs9r4MX5Gf_g@mail.gmail.com>
	<1301911604.2760.52.camel@localhost>
Date: Mon, 4 Apr 2011 12:29:47 +0200
Message-ID: <BANLkTi=DHTjL7M9bzYY-t5MJS2s1WScBCQ@mail.gmail.com>
Subject: Re: [PATCH] ubifs: Use empty_iops and empty_fops consistently
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 12:06 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Mon, 2011-04-04 at 11:38 +0200, Sedat Dilek wrote:
>> Sorry for having flooded your inbox.
>
> That's ok! :-) I think I did not look carefully enough. Your patch is
> just an additional clean-up which makes the names to be consistent. I
> can pick it, but probably it is better if it goes in with the
> 'empty_aops' changes? Whatever you prefer.
>

I dunno the internal organization between block-tree and fs-sub-tree
maintainers.
As I was in contact first with Jens in this issue, it might be a good
idea to let this patch go through his block-tree.

- Sedat -
