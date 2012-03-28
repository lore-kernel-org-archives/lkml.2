Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2C1VIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:08:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38321 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2C1VIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6s1GFkqgxsbKQWQxcoJZjTkkFHbAv3tqK2cPn6tho502w@mail.gmail.com>
References: <CACxGe6s1GFkqgxsbKQWQxcoJZjTkkFHbAv3tqK2cPn6tho502w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Mar 2012 14:08:22 -0700
X-Google-Sender-Auth: gLo2MY0PLb3MtsPyqLxVtqnwapI
Message-ID: <CA+55aFwN_=5UH0KrcnSUONxgfTtkmA45ND8Rq1n0tUv6+_-1hw@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO changes for v3.4
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 12:20 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
>
> Please pull.

You should double-check my trivial sleep control merge of the gpios vs
regulator code. It looked like a trivial context merge, but there may
be some subtle interactions on the actual device side that I have no
idea of. The author for both was the same, though, so I assume they
work together.

                  Linus
