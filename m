Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab2EKQ2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:28:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38463 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760610Ab2EKQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <4FACD573.4060103@kernel.org>
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
 <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com>
 <4FACD00D.4060003@kernel.org> <4FACD573.4060103@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 09:27:37 -0700
X-Google-Sender-Auth: UyKQ2vtTIrbzDErAUyup0Mnxkw4
Message-ID: <CA+55aFxsZqU4bXRz61ngnR2ozH=AAhwGHR+PqzdTRfnCxJY0oQ@mail.gmail.com>
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
To: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 2:01 AM, Minchan Kim <minchan@kernel.org> wrote:
>
> I didn't have a time so made quick patch to show just concept.
> Not tested and Not consider carefully.
> If anyone doesn't oppose, I will send formal patch which will have more beauty code.

What's so magical about that '8' *anyway*? We do we have that minimum at all?

At the very least, the 8-vs-0 thing needs to be explained.

                   Linus
