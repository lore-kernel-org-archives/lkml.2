Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2DXVSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:18:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49623 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2DXVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:18:32 -0400
MIME-Version: 1.0
In-Reply-To: <4F9717E6.8030506@amacapital.net>
References: <20120424161039.293018424@chello.nl> <4F9717E6.8030506@amacapital.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 14:18:09 -0700
X-Google-Sender-Auth: x3ZDOgET0c0e3tK939bZbharp5A
Message-ID: <CA+55aFxJHHnEf4nuB5VEKa5OLJ38nY1-tN8oA2JkoYoO6nRUAQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] gcc work-around and math128
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 2:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I played with some of this stuff awhile ago, and for timekeeping, it
> seemed like a 64x32->96 bit multiply followed by a right shift was
> enough, and that operation is a lot faster on 32-bit architectures than
> a full 64x64->128 multiply.

Ack. That may sound like odd numbers, but 64x32->96 sounds sane. And I
think it avoids a multiply even on 64-bit, no?

              Linus
