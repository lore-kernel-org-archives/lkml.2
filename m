Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1HXBAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:00:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009Ab1HXBAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110824004206.GG3162@dastard>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
 <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com> <20110824004206.GG3162@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 17:59:46 -0700
Message-ID: <CA+55aFwJAPN=EgTo-2iarhe4cFSArqB6AZAHDsuEK5EPBZVn+A@mail.gmail.com>
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 5:42 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> I consider the context it adds to cscope searches a damn good reason
> for keeping it.

Umm. I suggest you start learning to use the tools you have, rather
than blame your inability to use them for then making crap decisions
in file naming.

Read up on the "-pN" thing to cscope.

So here's a trick of the day:

  export CSCOPEOPTIONS=-p2

or something like that. And stop using crap to excuse bad decisions.

                      Linus
