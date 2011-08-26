Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1HZVAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:00:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab1HZU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <7vfwkndhc4.fsf@alter.siamese.dyndns.org>
References: <4E56CE8F.8080501@panasas.com> <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
 <7vfwkndhc4.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 13:59:35 -0700
Message-ID: <CA+55aFy=T82q==OxAzRfUgyfzMvy7=oeLOEAL8=rTJWOwkw-iA@mail.gmail.com>
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
To: Junio C Hamano <gitster@pobox.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 1:54 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> Not quite sure what you exactly mean by "extend it from just binary-vs-text".
> Do you mean update buffer_is_binary() and add source language detection?

Yes. Except the "detection" would be just "if we auto-detect it as
text, then use the standard file extensions to also make an automatic
hunk rule detection".

So it would do the most common cases (*.[Cch] etc)

                         Linus
