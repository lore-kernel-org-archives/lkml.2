Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HCL3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:29:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1HCL3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:29:33 -0400
Subject: Re: Use "make -s" to silence everything except warnings/error
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110803110502.GA18323@merkur.ravnborg.org>
References: <20110803110502.GA18323@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 13:28:55 +0200
Message-ID: <1312370935.1147.297.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 13:05 +0200, Sam Ravnborg wrote:
> Hi Peter.
> 
> Saw in an old thread that you mentioned that warnings were missed because
> your computer is too quick.
> 
> If you pass "-s" like this:
> 
>     make -s -j4 ...
> 
> then you will no longer see the one-line-per-file output.
> 
> But warnings are displayed and is thus much more visible.
> 
> Just a hint in case you did not know.

Ooh, nice. Thanks!

Maybe I'll even write an awk script that'll colour the warnings of
important bits like kernel/ and mm/ so as not to be confused with driver
noise.

Then again, it looks like my default config is now completely warning
free, so procrastination is likely :-)
