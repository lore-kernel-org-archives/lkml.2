Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1H2WDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:03:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab1H2WDa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <4E5BFD36.2090000@panasas.com>
References: <4E56CE8F.8080501@panasas.com> <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
 <4E580830.4010305@panasas.com> <1314624752.2816.32.camel@twins> <4E5BFD36.2090000@panasas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Aug 2011 15:02:35 -0700
Message-ID: <CA+55aFxB7mBByT9W4c0D6kELcZMZDD_j0_S2869nS4LV0mNTbA@mail.gmail.com>
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:57 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
>  What are you guys afraid of? what possibly could be bad about this patch?

I just detest filling the kernel tree with git stuff.

Right now, the only git-specific file we have in the kernel tree is
the ".gitignore" files, afaik. And if you were to use some other SCM,
the "ignore" model at least translates directly to just about anything
else (with the problem that the .gitignore model tends to be more
powerful than most other SCM's have, but whatever).

I'd hate to start populating the project with more stuff.

                     Linus
