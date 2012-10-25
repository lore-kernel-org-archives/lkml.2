Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2JYG3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:29:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57283 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2JYG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <59643.1351128330@turing-police.cc.vt.edu>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<59643.1351128330@turing-police.cc.vt.edu>
Date: Wed, 24 Oct 2012 23:29:10 -0700
X-Google-Sender-Auth: 4smo067vBaRfQe2whCeUkdxVWpE
Message-ID: <CAGXu5jLkGcccbA-NOFpTayzeHCy_cOHfbABYf4CJWrL5AxmNTQ@mail.gmail.com>
Subject: Re: [PATCH 000/193] remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 6:25 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 23 Oct 2012 13:01:13 -0700, Kees Cook said:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default (especially in distro builds). As agreed
>> during the Linux kernel summit, it should be removed.
>>
>> As such, this is the patch series for removing CONFIG_EXPERIMENTAL,
>> with the hopes of all the various maintainers pulling these changes into
>> their trees.  I'm carrying the first patch (that makes CONFIG_EXPERIMENTAL
>> "default y") in my linux-next tree, so builds there will see the impact
>> immediately.
>
> Has anybody tested what happens if you're doing a git bisect that ends up crossing
> back and forth across the commit for this?  I've been burned before when stuff
> evaporates out of my .config during a bisect when an option grows/loses a 'depends
> on' clause.

I haven't tried a bisect, but I've been bouncing around between trees
and haven't had any surprises yet.

-Kees

-- 
Kees Cook
Chrome OS Security
