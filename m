Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0GHR07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:26:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756465Ab0GHR06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:26:58 -0400
Date: Thu, 8 Jul 2010 10:25:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xiaosuo@gmail.com,
       tim.gardner@canonical.com, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 0/3] splice fixes
Message-Id: <20100708102544.2e4697f8.akpm@linux-foundation.org>
In-Reply-To: <4C35D4CE.6020401@kernel.dk>
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>
	<4C29D5B9.9040401@kernel.dk>
	<E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>
	<4C29E1A0.7070601@kernel.dk>
	<20100707133851.7c805c2d.akpm@linux-foundation.org>
	<4C35D466.8060007@kernel.dk>
	<4C35D4CE.6020401@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010 15:38:22 +0200 Jens Axboe <axboe@kernel.dk> wrote:

> >> However this:
> >>
> >> commit 4f9078afb4e083e033aafbbfabe729cb3832aa42
> >> Author: Changli Gao <xiaosuo@gmail.com>
> >> Date:   Tue Jun 29 13:09:18 2010 +0200
> >>
> >>     splice: direct_splice_actor() should not use pos in sd
> >>
> >> went into mainline without a cc:stable tag.
> > 
> > I will send an email to stable@.
> 
> BTW, it's not in mainline yet. I know I forgot to mark it as stable,
> but I can't tell them to include it before it's in mainline.

You could redo the changelog then.  But stable@kernel.org is cc'ed on
these emails and they're splendid chaps ;)

