Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1HZU2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:28:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab1HZU2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E56CE8F.8080501@panasas.com>
References: <4E56CE8F.8080501@panasas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 13:27:43 -0700
Message-ID: <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 3:37 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> Add a .gitattributes file to the Linux tree to enable cpp parsing
> of the source files.

Hmm. I'm not entirely conviced. If people really think that the hunk
description matters that much, maybe we should just instead improve on
the automatic diff detection, and extend it from just binary-vs-text,
to also do the common hunk-headers.

After all, not having a diff pattern already *does* mean "automatic",
so it would be just a rather trivial extension to that.

Junio?

                     Linus
