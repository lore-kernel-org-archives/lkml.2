Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1HZUz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:55:28 -0400
Received: from natasha.panasas.com ([67.152.220.90]:41051 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1HZUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:55:26 -0400
Message-ID: <4E580830.4010305@panasas.com>
Date: Fri, 26 Aug 2011 13:55:12 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
References: <4E56CE8F.8080501@panasas.com> <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
In-Reply-To: <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 01:27 PM, Linus Torvalds wrote:
> On Thu, Aug 25, 2011 at 3:37 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> Add a .gitattributes file to the Linux tree to enable cpp parsing
>> of the source files.
> 
> Hmm. I'm not entirely conviced. If people really think that the hunk
> description matters that much, maybe we should just instead improve on
> the automatic diff detection, and extend it from just binary-vs-text,
> to also do the common hunk-headers.
> 
> After all, not having a diff pattern already *does* mean "automatic",
> so it would be just a rather trivial extension to that.
> 
> Junio?
> 

There was a patch submitted for new git version to auto detect file
extensions and do the right thing. 
(Look for the thread "git diff annoyance / feature request" on the git
 mailing list)

But this patch is for all the people and distributions that are going
to use the old git versions for a while, (Years).

It is important for the Linux mailing-list review, because you get
patches with:

@@@ lable out:
-	change foo
+	to bazz

And how the hell are you suppose to know where in the file it is.
This is such a trivial addition, that can help unify everyone's
usage. I don't see the down sides.

Thanks
Boaz

>                      Linus
