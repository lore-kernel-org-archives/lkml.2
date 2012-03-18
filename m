Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2CRWJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 18:09:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35203 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2CRWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 18:09:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120318220751.GD6589@ZenIV.linux.org.uk>
References: <20120318190744.GA6589@ZenIV.linux.org.uk> <CA+55aFwBEoD167oD=X9d6jR+wn6Tb-QFgZR+wGwdej4qakCMgg@mail.gmail.com>
 <20120318220610.GC6589@ZenIV.linux.org.uk> <20120318220751.GD6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2012 15:09:32 -0700
X-Google-Sender-Auth: nO7zLZj_GaD6oUgByBfOrAdgJiU
Message-ID: <CA+55aFz-hTQ88fq3_PGSX2UmvxPHm0+vTQYM0nV1_a-u0q-BOQ@mail.gmail.com>
Subject: Re: [rfc][patches] fix for munmap/truncate races
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 3:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Nope - ia64 check explicitly for precisely that case:
> [snip]
> ... and everything else doesn't look at start or end at all.

Ok, then I don't really care, and it certainly simplifies the calling
conventions.

                   Linus
