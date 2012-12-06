Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422670Ab2LFJiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:38:01 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59357 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2LFJh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:37:58 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Thu, 6 Dec 2012 10:37:56 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc8-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121206011402.GB27172@dastard> <CA+55aFzjOr1tw4UAdWazgvzOu6if8hOc4PqgLeX4Um_k-kuguw@mail.gmail.com> (sfid-20121206_101846_967501_50CDB52C)
In-Reply-To: <CA+55aFzjOr1tw4UAdWazgvzOu6if8hOc4PqgLeX4Um_k-kuguw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201212061037.56597.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2012 schrieb Linus Torvalds:
> On Wed, Dec 5, 2012 at 5:14 PM, Dave Chinner <david@fromorbit.com> 
wrote:
> > And for changes to syscalls? That's something that must be peer
> > reviewed because we are going to be stuck with those changes forever
> > as we can't undo them at a later date. It doesn't matter who made the
> > change in question, I would have done exactly the same thing....
> 
> The thing that people are complaining about is exactly the reverse of
> this. It's *protecting* us from making mistakes, and doesn't actually
> add any new interfaces in itself.
>
> This is why I'm so annoyed with this stupid thread. It's been going on
> forever, and reverting that change WOULD BE OBJECTIVELY A BAD IDEA.

See, thats where you have a problem with "reality".

It seems you cannot accept the fact that some developers disliked the 
process in which this change was pushed. It seems to be that you want this 
thread to vanish in thin air immediately. But unfortunately it didn´t.

So while the process generally is fluid, I agree to that, it wasn´t fluid 
here. Or would you call this fluid here?

I accept the fact that a decision has been made. And I am not deeply 
enough into the technical matters to have to continue discussing it. I 
also think all arguments have been said.

The process has been the way it is. Noted. For the future there is 
potential to do it differently with less churn involved. Will you, Ted and 
others involved take the chance? Up to you entirely. And depending on what 
effect you want to create.

BTW: I do not buy into your tough guy number. Scare someone else with 
that, if it makes you feel better about yourself. So thanks for the 
factual stuff that you delivered after your first post to the thread.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
