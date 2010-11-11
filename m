Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0KKWI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:08:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775Ab0KKWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:08:27 -0500
MIME-Version: 1.0
In-Reply-To: <20101111002702.GA3477@amd>
References: <20101109124610.GB11477@amd> <20101109130133.GE11477@amd>
 <20101109162516.GB6217@infradead.org> <20101109220833.GG3246@amd>
 <20101110163224.GB15130@infradead.org> <20101111002702.GA3477@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Nov 2010 14:07:36 -0800
Message-ID: <AANLkTimyQvo5PPjvk-3u3uCfK--YdDi0qM=smt+g=gN-@mail.gmail.com>
Subject: Re: [patch 4/6] fs: d_delete change
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 4:27 PM, Nick Piggin <npiggin@kernel.dk> wrote:
>
> Right, I'll switch to a different way of commenting that git-am
> does not pick up.

The standard way is to just put it after the "---" thing. So you end
up having the actual kernel changelog at the top (which is, after all,
the summary and should be readable on its own, so making people read
that first makes perfect sense), and then put the extended explanation
that doesn't make sense for the changelog after the "---".

Of course, quite often you would want the commit message to be
exhaustive, so maybe the extended explanation ends up making sense for
the changelog too. But if it's more of a "discussion material" thing
(eg things like "Hi guys, this is _why_ I think this is the right
approach: ...") that way it's clear both to tools and by now to most
developers that the stuff that comes after the "---" is really
extended material.

                      Linus
