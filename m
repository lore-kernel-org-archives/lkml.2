Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab1HIBIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 21:08:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48102 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1HIBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 21:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110808212418.GA3297@joi.lan>
References: <1312709438-7608-1-git-send-email-akinobu.mita@gmail.com>
	<20110808212418.GA3297@joi.lan>
Date: Tue, 9 Aug 2011 10:08:12 +0900
Message-ID: <CAC5umyg=zq7BxSrFLtkkpMpKheW7k++KLmQkAfmk56vKn8EykQ@mail.gmail.com>
Subject: Re: [PATCH] slub: fix check_bytes() for slub debugging
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/9 Marcin Slusarz <marcin.slusarz@gmail.com>:

> I tested your patch to check if performance improvements of commit
> c4089f98e943ff445665dea49c190657b34ccffe come from this bug or not.
> And forunately they aren't - performance is exactly the same.

That's good to know.

> How did you find it?

When I tried to reuse it in mm/debug-pagealloc.c, I realized that
check_bytes() didn't work with 0xaa.
